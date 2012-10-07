// PFOR and PFOR-DELTA Compression and decompression routines

#include <stdio.h>
#include <fstream>
#include <iomanip>
#include <exception>
#include <thrust/device_vector.h>
#include <thrust/iterator/discard_iterator.h>
#include <thrust/extrema.h>
#include "sorts.cu"

using namespace std;

struct bool_to_int
{
    __host__ __device__
    unsigned int operator()(const bool x)
    {
        return (unsigned int)x;
    }
};

struct ui_to_ll
{
    __host__ __device__
    long long int operator()(const unsigned int x)
    {
        return (long long int)x;
    }
};

template<typename T>
struct nz
{
    __host__ __device__
    bool operator()(const T x)
    {
        return (x != 0);
    }
};


struct compress_functor_int
{

    const int_type * source;
    unsigned long long int * dest;
    const long long int * start_val;
    const unsigned int * vals;


    compress_functor_int(const int_type * _source, unsigned long long int  * _dest,
                         const long long int * _start_val, const unsigned int * _vals):
        source(_source), dest(_dest), start_val(_start_val), vals(_vals) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        long long int val = source[i] - start_val[0];;
        unsigned int shifted = vals[2] - vals[0] - (i%vals[1])*vals[0];
        dest[i] = val << shifted;
    }
};

struct compress_functor_float
{

    const long long int * source;
    unsigned long long int * dest;
    const long long int * start_val;
    const unsigned int * vals;


    compress_functor_float(const long long int * _source, unsigned long long int  * _dest,
                           const long long int * _start_val, const unsigned int * _vals):
        source(_source), dest(_dest), start_val(_start_val), vals(_vals) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        long long int val;

        unsigned int bits = vals[0];
        unsigned int fit_count = vals[1];
        unsigned int int_sz = vals[2];

        val = source[i] - start_val[0];
        unsigned int z = i%fit_count;

        unsigned int shifted = int_sz - bits - z*bits;
        dest[i] = val << shifted;
    }
};



struct decompress_functor_int
{

    const unsigned long long int * source;
    int_type * dest;
    const long long int * start_val;
    const unsigned int * vals;


    decompress_functor_int(const unsigned long long int * _source, int_type * _dest,
                           const long long int * _start_val, const unsigned int * _vals):
        source(_source), dest(_dest), start_val(_start_val), vals(_vals) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {


        unsigned int bits = vals[0];
        unsigned int fit_count = vals[1];
        unsigned int int_sz = vals[2];

        //find the source index
        unsigned int src_idx = i/fit_count;
        // find the exact location
        unsigned int src_loc = i%fit_count;
        //right shift the values
        unsigned int shifted = int_sz - bits - src_loc*bits;
        unsigned long long int tmp = source[src_idx]  >> shifted;
        // set  the rest of bits to 0
        tmp	= tmp << (int_sz - bits);
        tmp	= tmp >> (int_sz - bits);

        dest[i] = tmp + start_val[0];

    }
};


struct decompress_functor_float
{

    const unsigned long long int * source;
    long long int * dest;
    const long long int * start_val;
    const unsigned int * vals;


    decompress_functor_float(const unsigned long long int * _source, long long int * _dest,
                             const long long int * _start_val, const unsigned int * _vals):
        source(_source), dest(_dest), start_val(_start_val), vals(_vals) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {


        unsigned int bits = vals[0];
        unsigned int fit_count = vals[1];
        unsigned int int_sz = vals[2];

        //find the source index
        unsigned int src_idx = i/fit_count;
        // find the exact location
        unsigned int src_loc = i%fit_count;
        //right shift the values
        unsigned int shifted = int_sz - bits - src_loc*bits;
        unsigned long long int tmp = source[src_idx]  >> shifted;
        // set  the rest of bits to 0
        tmp	= tmp << (int_sz - bits);
        tmp	= tmp >> (int_sz - bits);

        dest[i] = tmp + start_val[0];

    }
};




long long int pfor_dict_decompress(void* compressed, std::vector<thrust::host_vector<char> >& h_columns, std::vector<thrust::device_vector<char> >& d_columns, unsigned int* mRecCount, FILE* f, bool mode, unsigned int mColumnCount, 
                                   unsigned int offset, void* d_v, void* s_v)
{

    unsigned int bits, cnt, fit_count, orig_recCount, grp_count;
    long long int  orig_lower_val;
    unsigned int bit_count = 64;
    unsigned int comp_type;
    long long int start_val;


    if (f) {
        fread((char *)&grp_count, 4, 1, f);
        fread((char *)&cnt, 4, 1, f);
        fread((char *)&orig_recCount, 4, 1, f);
        fread((char *)&bits, 4, 1, f);
        fread((char *)&orig_lower_val, 8, 1, f);
        fread((char *)&fit_count, 4, 1, f);
        fread((char *)&start_val, 8, 1, f);
        fread((char *)&comp_type, 4, 1, f);
    }
    else {
        cnt = ((unsigned int*)compressed)[0];
        grp_count = ((unsigned int*)((char*)compressed + 8*cnt + 12))[0];
        orig_recCount = ((unsigned int*)((char*)compressed + 8*cnt +8))[0];
        bits = ((unsigned int*)((char*)compressed + 8*cnt + mColumnCount*grp_count + 28))[0];
        orig_lower_val = ((long long int*)((char*)compressed + 8*cnt + mColumnCount*grp_count + 32))[0];
        fit_count = ((unsigned int*)((char*)compressed + 8*cnt + mColumnCount*grp_count + 40))[0];
        start_val = ((long long int*)((char*)compressed + 8*cnt + mColumnCount*grp_count + 44))[0];
        comp_type  = ((unsigned int*)((char*)compressed + 8*cnt + mColumnCount*grp_count + 52))[0];
    };
    *mRecCount = orig_recCount;

  //  cout << "DICT Decomp Header " << cnt << " " << grp_count << " " << orig_recCount << " " << bits << " " << orig_lower_val << " " << fit_count << " " << start_val << " " << comp_type  << endl;

    thrust::device_ptr<unsigned long long int> decomp = thrust::device_malloc<unsigned long long int>(cnt);
    unsigned long long int* raw_decomp = thrust::raw_pointer_cast(decomp);
    if (f)
        cudaMemcpy( (void*)raw_decomp, (void*)compressed, cnt*8, cudaMemcpyHostToDevice);
    else
        cudaMemcpy( (void*)raw_decomp, (void*)((unsigned int*)compressed + 1), cnt*8, cudaMemcpyHostToDevice);

    //void* d_v;
    //CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);

    //void* s_v;
    //CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));
    thrust::device_ptr<long long int> dd_sv((long long int*)s_v);



    dd_sv[0] = orig_lower_val;
    dd_v[0] = bits;
    dd_v[1] = fit_count;
    dd_v[2] = bit_count;

    thrust::device_ptr<unsigned long long int> dest = thrust::device_malloc<unsigned long long int>(orig_recCount);
	thrust::counting_iterator<unsigned int, thrust::device_space_tag> begin(0);
    decompress_functor_int ff1(raw_decomp,(int_type*)thrust::raw_pointer_cast(dest), (long long int*)s_v, (unsigned int*)d_v);
    thrust::for_each(begin, begin + orig_recCount, ff1);

    //cudaFree(d_v);
    //cudaFree(s_v);
    thrust::device_free(decomp);


    if(mode == 0) {                   // keep results in gpu

        thrust::device_ptr<char> dict = thrust::device_malloc<char>(grp_count);

        for(unsigned int i = 0; i < mColumnCount; i++) {
            if(f)
                thrust::copy(h_columns[i].begin()+offset, h_columns[i].begin()+offset+grp_count,dict);
            else
                cudaMemcpy( (void*)thrust::raw_pointer_cast(dict), (void*)((char*)compressed + 8*cnt + 16 + i*grp_count) , grp_count, cudaMemcpyHostToDevice);
            thrust::gather(dest, dest+orig_recCount,dict, d_columns[i].begin() + offset);
        }
        thrust::device_free(dict);
    }
    else {
        thrust::device_ptr<char> dict = thrust::device_malloc<char>(grp_count);
        thrust::device_ptr<char> d_col = thrust::device_malloc<char>(orig_recCount);

        for(unsigned int i = 0; i < mColumnCount; i++) {
            thrust::copy(h_columns[i].begin()+offset, h_columns[i].begin()+offset+grp_count,dict);
            thrust::gather(dest, dest+orig_recCount,dict, d_col);
            thrust::copy(d_col, d_col+orig_recCount,h_columns[i].begin() +offset);
        }
        thrust::device_free(dict);
        thrust::device_free(d_col);

    };
    thrust::device_free(dest);

    return 1;
}






long long int pfor_decompress(void* destination, void* host, unsigned int* mRecCount, bool tp, FILE* f, void* d_v, void* s_v)
{

    unsigned int bits, cnt, fit_count, orig_recCount;
    long long int  orig_lower_val;
    unsigned int bit_count = 64;
    unsigned int comp_type;
    long long int start_val;

    if(f) {
        fread((char *)&cnt, 4, 1, f);
        fread((char *)&cnt, 4, 1, f);
        fread((char *)&orig_recCount, 4, 1, f);
        fread((char *)&bits, 4, 1, f);
        fread((char *)&orig_lower_val, 8, 1, f);
        fread((char *)&fit_count, 4, 1, f);
        fread((char *)&start_val, 8, 1, f);
        fread((char *)&comp_type, 4, 1, f);
        fread((char *)&comp_type, 4, 1, f);
    }
    else {
        cnt = ((unsigned int*)host)[0];
        orig_recCount = ((unsigned int*)host + cnt*2)[7];
        bits = ((unsigned int*)host + cnt*2)[8];
        orig_lower_val = ((long long int*)((unsigned int*)host + cnt*2 + 9))[0];
        fit_count = ((unsigned int*)host + cnt*2)[11];
        start_val = ((long long int*)((unsigned int*)host + cnt*2 + 12))[0];
        comp_type = ((unsigned int*)host + cnt*2)[14];
    };
    *mRecCount = orig_recCount;

//	cout << "Decomp Header " << orig_recCount << " " << bits << " " << orig_lower_val << " " << cnt << " " << fit_count << " " << comp_type << endl;

    thrust::device_ptr<unsigned long long int> decomp = thrust::device_malloc<unsigned long long int>(cnt);


    unsigned long long int* raw_decomp = thrust::raw_pointer_cast(decomp);
    if(f)
        cudaMemcpy( (void*)raw_decomp, host, cnt*8, cudaMemcpyHostToDevice);
    else
        cudaMemcpy( (void*)raw_decomp, (void*)((unsigned int*)host + 5), cnt*8, cudaMemcpyHostToDevice);

//    void* d_v;
//    cudaMalloc((void **) &d_v, 12);
    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);

//    void* s_v;
//    cudaMalloc((void **) &s_v, 8);
    thrust::device_ptr<long long int> dd_sv((long long int*)s_v);

    dd_sv[0] = orig_lower_val;
    dd_v[0] = bits;
    dd_v[1] = fit_count;
    dd_v[2] = bit_count;


    thrust::counting_iterator<unsigned int, thrust::device_space_tag> begin(0);
    if(tp == 0) {
        decompress_functor_int ff1(raw_decomp,(int_type*)destination, (long long int*)s_v, (unsigned int*)d_v);
        thrust::for_each(begin, begin + orig_recCount, ff1);
        if(comp_type == 1) {
            thrust::device_ptr<int_type> d_int((int_type*)destination);
            d_int[0] = start_val;
            thrust::inclusive_scan(d_int, d_int + orig_recCount, d_int);
        };
    }
    else {

        decompress_functor_float ff1(raw_decomp,(long long int*)destination, (long long int*)s_v, (unsigned int*)d_v);
        thrust::for_each(begin, begin + orig_recCount, ff1);
        if(comp_type == 1) {
            thrust::device_ptr<long long int> d_int((long long int*)destination);
            d_int[0] = start_val;
            thrust::inclusive_scan(d_int, d_int + orig_recCount, d_int);
        };

    };
//    cudaFree(d_v);
//    cudaFree(s_v);
    thrust::device_free(decomp);
    return 1;

}


template< typename T>
unsigned long long int pfor_delta_compress(void* source, unsigned int source_len, char* file_name, thrust::host_vector<T>& host, bool tp, unsigned long long int sz)
{
    long long int orig_lower_val, orig_upper_val, start_val, real_lower, real_upper;
    unsigned int  bits, recCount;
    unsigned int bit_count = 8*8;
    unsigned int fit_count;
    unsigned int comp_type = 1; // FOR-DELTA

    if(tp == 0)
        recCount = source_len/int_size;
    else
        recCount = source_len/float_size;

    void* ss;
    CUDA_SAFE_CALL(cudaMalloc((void **) &ss, recCount*float_size));



    if (tp == 0) {
        thrust::device_ptr<int_type> s((int_type*)source);
        thrust::device_ptr<int_type> d_ss((int_type*)ss);
        thrust::adjacent_difference(s, s+recCount, d_ss);

        start_val = d_ss[0];
        if(recCount > 1)
            d_ss[0] = d_ss[1];

        orig_lower_val = *(thrust::min_element(d_ss, d_ss + recCount));
        orig_upper_val = *(thrust::max_element(d_ss, d_ss + recCount));

        real_lower = s[0];
        real_upper = s[recCount-1];
        //cout << "orig " << orig_upper_val << " " <<  orig_lower_val << endl;
        //cout << "We need for delta " << (unsigned int)ceil(log2((double)((orig_upper_val-orig_lower_val)+1))) << " bits to encode " <<  orig_upper_val-orig_lower_val << " values " << endl;
        bits = (unsigned int)ceil(log2((double)((orig_upper_val-orig_lower_val)+1)));
        if (bits == 0)
            bits = 1;

    }
    else {
        thrust::device_ptr<long long int> s((long long int*)source);
        thrust::device_ptr<long long int> d_ss((long long int*)ss);
        thrust::adjacent_difference(s, s+recCount, d_ss);
        start_val = d_ss[0];
        if(recCount > 1)
            d_ss[0] = d_ss[1];

        orig_lower_val = *(thrust::min_element(d_ss, d_ss + recCount));
        orig_upper_val = *(thrust::max_element(d_ss, d_ss + recCount));
        real_lower = s[0];
        real_upper = s[recCount-1];

        //cout << "orig " << orig_upper_val << " " <<  orig_lower_val << endl;
        //cout << "We need for delta " << (unsigned int)ceil(log2((double)((orig_upper_val-orig_lower_val)+1))) << " bits to encode " << orig_upper_val-orig_lower_val << " values" << endl;
        bits = (unsigned int)ceil(log2((double)((orig_upper_val-orig_lower_val)+1)));
        if (bits == 0)
            bits = 1;
    };

    thrust::counting_iterator<unsigned int, thrust::device_space_tag> begin(0);

    fit_count = bit_count/bits;
    void* d_v;
    CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);

    void* s_v;
    CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));
    thrust::device_ptr<long long int> dd_sv((long long int*)s_v);

    dd_sv[0] = orig_lower_val;
    dd_v[0] = bits;
    dd_v[1] = fit_count;
    dd_v[2] = bit_count;


    //void* d;
    //CUDA_SAFE_CALL(cudaMalloc((void **) &d, recCount*float_size));

    thrust::device_ptr<char> dd((char*)source);
    thrust::fill(dd, dd+source_len,0);

    //cout << "FF " << orig_lower_val << " " << bits << " " << fit_count << " " << bit_count << endl;

    if (tp == 0) {
        compress_functor_int ff((int_type*)ss,(unsigned long long int*)source, (long long int*)s_v, (unsigned int*)d_v);
        thrust::for_each(begin, begin + recCount, ff);
    }
    else {
        compress_functor_float ff((long long int*)ss,(unsigned long long int*)source, (long long int*)s_v, (unsigned int*)d_v);
        thrust::for_each(begin, begin + recCount, ff);
    };


    thrust::device_ptr<unsigned long long int> s_copy1((unsigned long long int*)source);

    // make an addition  sequence

    thrust::device_ptr<unsigned long long int> add_seq((unsigned long long int*)ss);
    thrust::constant_iterator<unsigned long long int> iter(fit_count);
    thrust::sequence(add_seq, add_seq + recCount, 0, 1);
    thrust::transform(add_seq, add_seq + recCount, iter, add_seq, thrust::divides<unsigned long long int>());

    unsigned int cnt = (recCount)/fit_count;
    if (recCount%fit_count > 0)
        cnt++;
    thrust::device_ptr<unsigned long long int> fin_seq = thrust::device_malloc<unsigned long long int>(cnt);

    thrust::reduce_by_key(add_seq, add_seq+recCount,s_copy1,thrust::make_discard_iterator(),
                          fin_seq);

    //for(int i = 0; i < 10;i++)
    //  cout << "FIN " << fin_seq[i] << endl;

    // copy fin_seq to host
    unsigned long long int * raw_src = thrust::raw_pointer_cast(fin_seq);

    if(file_name) {
        cudaMemcpy( host.data(), (void *)raw_src, cnt*8, cudaMemcpyDeviceToHost);
        fstream binary_file(file_name,ios::out|ios::binary|ios::app);
        binary_file.write((char *)&cnt, 4);
        binary_file.write((char *)&real_lower, 8);
        binary_file.write((char *)&real_upper, 8);
        binary_file.write((char *)host.data(),cnt*8);
        binary_file.write((char *)&comp_type, 4);
        binary_file.write((char *)&cnt, 4);
        binary_file.write((char *)&recCount, 4);
        binary_file.write((char *)&bits, 4);
        binary_file.write((char *)&orig_lower_val, 8);
        binary_file.write((char *)&fit_count, 4);
        binary_file.write((char *)&start_val, 8);
        binary_file.write((char *)&comp_type, 4);
        binary_file.write((char *)&comp_type, 4); //filler
        binary_file.close();
    }
    else {
        char* hh;
        //resize_compressed(host, sz, cnt*8 + 15*4, 0);
        host.resize(sz+cnt+8);
        hh = (char*)(host.data() + sz);
        ((unsigned int*)hh)[0] = cnt;
        ((long long int*)(hh+4))[0] = real_lower;
        ((long long int*)(hh+12))[0] = real_upper;
        cudaMemcpy( hh + 20, (void *)raw_src, cnt*8, cudaMemcpyDeviceToHost);
        ((unsigned int*)hh)[5+cnt*2] = comp_type;
        ((unsigned int*)hh)[6+cnt*2] = cnt;
        ((unsigned int*)hh)[7+cnt*2] = recCount;
        ((unsigned int*)hh)[8+cnt*2] = bits;
        ((long long int*)((char*)hh+36+cnt*8))[0] = orig_lower_val;
        ((unsigned int*)hh)[11+cnt*2] = fit_count;
        ((long long int*)((char*)hh+48+cnt*8))[0] = start_val;
        ((unsigned int*)hh)[14+cnt*2] = comp_type;
    };

    thrust::device_free(fin_seq);
    cudaFree(ss);
    cudaFree(d_v);
    cudaFree(s_v);
    return sz + cnt + 8;
}

unsigned long long int pfor_dict_compress(std::vector<thrust::device_vector<char> >& d_columns, unsigned int mColumnCount, char* file_name, unsigned int source_len, thrust::host_vector<char>& host, unsigned long long int sz)
{
    unsigned int comp_type = 2; // DICT
    long long int start_val = 0;
    long long int orig_lower_val;

    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(source_len);
    thrust::sequence(permutation, permutation+source_len);
    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);

    void* temp;
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, source_len));

    for(int j=mColumnCount-1; j>=0 ; j--)
        update_permutation(d_columns[j], raw_ptr, source_len, "ASC", (char*)temp);

    for(int j=mColumnCount-1; j>=0 ; j--)
        apply_permutation(d_columns[j], raw_ptr, source_len, (char*)temp);

    cudaFree(temp);

// group by the vectors
    bool *grp;
    CUDA_SAFE_CALL(cudaMalloc((void **) &grp, source_len * sizeof(bool)));
    thrust::device_ptr<bool> d_grp(grp);
    thrust::sequence(d_grp, d_grp+source_len, 0, 0);

    thrust::device_ptr<bool> d_group = thrust::device_malloc<bool>(source_len);
    d_group[source_len-1] = 1;

    for(unsigned int j=0; j < mColumnCount; j++) {
        //thrust::device_ptr<char> d_col(d_columns[j]);
        thrust::transform(d_columns[j].begin(), d_columns[j].begin() + source_len - 1, d_columns[j].begin()+1, d_group, thrust::not_equal_to<char>());
        thrust::transform(d_group, d_group+source_len, d_grp, d_grp, thrust::logical_or<int>());
    };


    thrust::device_free(d_group);
    thrust::device_ptr<unsigned int> d_grp_int = thrust::device_malloc<unsigned int>(source_len);
    thrust::transform(d_grp, d_grp+source_len, d_grp_int, bool_to_int());
    //thrust::device_free(d_grp);
    unsigned int grp_count = thrust::reduce(d_grp_int, d_grp_int+source_len);
    if(grp_count == 1)
        grp_count++;

    //if(grp_count < source_len)
//        cout << "Compressable to " << grp_count << endl;
//    cout << "grp count " << grp_count << endl;

    unsigned int bits = (unsigned int)log2((double)(grp_count))+1;

    thrust::device_ptr<int_type> permutation_final = thrust::device_malloc<int_type>(source_len);

    thrust::exclusive_scan(d_grp_int, d_grp_int+source_len, d_grp_int, 0);
    thrust::scatter(d_grp_int, d_grp_int+source_len, permutation, permutation_final);
    thrust::device_free(permutation);


//	for(int z = 0; z < 10; z++)
//	cout << "RES " << permutation_final[z] << endl;

    unsigned int fit_count = 64/bits;

    void* d_v;
    CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);

    void* s_v;
    CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));
    thrust::device_ptr<long long int> dd_sv((long long int*)s_v);

    dd_sv[0] = 0;
    dd_v[0] = bits;
    dd_v[1] = fit_count;
    dd_v[2] = 64;

    thrust::counting_iterator<unsigned int, thrust::device_space_tag> begin(0);

    void* d;
    CUDA_SAFE_CALL(cudaMalloc((void **) &d, source_len*float_size));

    thrust::device_ptr<char> dd((char*)d);
    thrust::fill(dd, dd+source_len,0);

    compress_functor_int ff(thrust::raw_pointer_cast(permutation_final),(unsigned long long int*)d, (long long int*)s_v, (unsigned int*)d_v);
    thrust::for_each(begin, begin + source_len, ff);

    cudaFree(d_v);
    cudaFree(s_v);

    thrust::device_ptr<unsigned long long int> s_copy1((unsigned long long int*)d);

    // make an addition  sequence
    thrust::constant_iterator< long long int> iter(fit_count);
    thrust::sequence(permutation_final, permutation_final + source_len, 0, 1);
    thrust::transform(permutation_final, permutation_final + source_len, iter, permutation_final, thrust::divides<long long int>());


    unsigned int cnt = (source_len)/fit_count;
    if (source_len%fit_count > 0)
        cnt++;
    thrust::device_ptr<unsigned long long int> fin_seq = thrust::device_malloc<unsigned long long int>(cnt);

    //cout << "fin seq " << cnt << " " << source_len <<  endl;

    thrust::reduce_by_key(permutation_final, permutation_final+source_len,s_copy1,thrust::make_discard_iterator(), fin_seq);
    orig_lower_val = 0;

    if (file_name) {
        cudaMemcpy( host.data(), (void *)thrust::raw_pointer_cast(fin_seq), cnt*8, cudaMemcpyDeviceToHost);
        //thrust::copy(fin_seq, fin_seq+cnt,host.begin());
        thrust::device_free(fin_seq);
        fstream binary_file(file_name,ios::out|ios::binary|ios::app);
        binary_file.write((char *)&cnt, 4);
        binary_file.write((char *)host.data(),cnt*8);
        binary_file.write((char *)&comp_type, 4);
        binary_file.write((char *)&source_len, 4);

        // write a dictionary
        binary_file.write((char *)&grp_count, 4);
        // create dictionary
        thrust::device_ptr<char> dict = thrust::device_malloc<char>(grp_count);
        for(unsigned int j=0; j < mColumnCount; j++) {
            thrust::transform(d_grp, d_grp+source_len, d_grp_int, bool_to_int());
            thrust::copy_if(d_columns[j].begin(),d_columns[j].begin()+source_len,d_grp_int, dict, nz<unsigned int>());
            cudaMemcpy( host.data(), (void *)thrust::raw_pointer_cast(dict), grp_count, cudaMemcpyDeviceToHost);
            binary_file.write((char *)host.data(),grp_count);
        };
        thrust::device_free(dict);
        binary_file.write((char *)&grp_count, 4);
        binary_file.write((char *)&cnt, 4);
        binary_file.write((char *)&source_len, 4);
        binary_file.write((char *)&bits, 4);
        binary_file.write((char *)&orig_lower_val, 8);
        binary_file.write((char *)&fit_count, 4);
        binary_file.write((char *)&start_val, 8);
        binary_file.write((char *)&comp_type, 4);
        binary_file.close();
    }
    else {
        char* hh;
        host.resize(sz+cnt*8 + mColumnCount*grp_count + 14*4);
        hh = (host.data() + sz);
        ((unsigned int*)hh)[0] = cnt;
        cudaMemcpy( (unsigned int*)hh + 1, (void *)thrust::raw_pointer_cast(fin_seq), cnt*8, cudaMemcpyDeviceToHost);
        thrust::device_free(fin_seq);
        ((unsigned int*)hh)[1+cnt*2] = comp_type;
        ((unsigned int*)hh)[2+cnt*2] = source_len;
        // write a dictionary
        ((unsigned int*)hh)[3+cnt*2] = grp_count;
        // create dictionary
        thrust::device_ptr<char> dict = thrust::device_malloc<char>(grp_count);
        for(unsigned int j=0; j < mColumnCount; j++) {
            thrust::transform(d_grp, d_grp+source_len, d_grp_int, bool_to_int());
            thrust::copy_if(d_columns[j].begin(),d_columns[j].begin()+source_len,d_grp_int, dict, nz<unsigned int>());
            cudaMemcpy( (void*)(hh+16+cnt*8+j*grp_count), (void *)thrust::raw_pointer_cast(dict), grp_count, cudaMemcpyDeviceToHost);
        };
        thrust::device_free(dict);
        ((unsigned int*)(hh+16+cnt*8+mColumnCount*grp_count))[0] = grp_count;
        ((unsigned int*)(hh+20+cnt*8+mColumnCount*grp_count))[0] = cnt;
        ((unsigned int*)(hh+24+cnt*8+mColumnCount*grp_count))[0] = source_len;
        ((unsigned int*)(hh+28+cnt*8+mColumnCount*grp_count))[0] = bits;
        ((long long int*)(hh+32+cnt*8+mColumnCount*grp_count))[0] = orig_lower_val;
        ((unsigned int*)(hh+40+cnt*8+mColumnCount*grp_count))[0] = fit_count;
        ((long long int*)(hh+44+cnt*8+mColumnCount*grp_count))[0] = start_val;
        ((unsigned int*)(hh+52+cnt*8+mColumnCount*grp_count))[0] = comp_type;
    };


    thrust::device_free(permutation_final);
    thrust::device_free(d_grp_int);
    cudaFree(d);
    thrust::device_free(d_grp);

    return sz + cnt*8 + mColumnCount*grp_count + 14*4;

}

template< typename T>
unsigned long long int pfor_compress(void* source, unsigned int source_len, char* file_name, thrust::host_vector<T>& host,  bool tp, unsigned long long int sz)
{
    unsigned int recCount;
    long long int orig_lower_val;
    long long int orig_upper_val;
    unsigned int  bits;
    unsigned int bit_count = 8*8;
    unsigned int fit_count;
    unsigned int comp_type = 0; // FOR
    long long int start_val = 0;
    bool sorted = 0;

    if(tp == 0)
        recCount = source_len/int_size;
    else
        recCount = source_len/float_size;

    // check if sorted

    if (tp == 0) {
        thrust::device_ptr<int_type> s((int_type*)source);
        sorted = thrust::is_sorted(s, s+recCount);
    }
    else {
        thrust::device_ptr<long long int> s((long long int*)source);
        sorted = thrust::is_sorted(s, s+recCount);
    };

    if(sorted)
        return pfor_delta_compress(source, source_len, file_name, host, tp, sz);

// sort the sequence

    if (tp == 0) {
        thrust::device_ptr<int_type> s((int_type*)source);

        orig_lower_val = *(thrust::min_element(s, s + recCount));
        orig_upper_val = *(thrust::max_element(s, s + recCount));

        //cout << "We need " << (unsigned int)ceil(log2((double)((orig_upper_val - orig_lower_val) + 1))) << " bits to encode original range of " << orig_lower_val << " to " << orig_upper_val << endl;
        bits = (unsigned int)ceil(log2((double)((orig_upper_val - orig_lower_val) + 1)));
    }
    else {
        thrust::device_ptr<long long int> s((long long int*)source);

        orig_lower_val = *(thrust::min_element(s, s + recCount));
        orig_upper_val = *(thrust::max_element(s, s + recCount));

        //cout << "We need " << (unsigned int)ceil(log2((double)((orig_upper_val - orig_lower_val) + 1))) << " bits to encode original range of " << orig_lower_val << " to " << orig_upper_val << endl;
        bits = (unsigned int)ceil(log2((double)((orig_upper_val - orig_lower_val) + 1)));
    };

    thrust::counting_iterator<unsigned int, thrust::device_space_tag> begin(0);

    fit_count = bit_count/bits;
    void* d_v;
    CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);

    void* s_v;
    CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));
    thrust::device_ptr<long long int> dd_sv((long long int*)s_v);

    dd_sv[0] = orig_lower_val;
    dd_v[0] = bits;
    dd_v[1] = fit_count;
    dd_v[2] = bit_count;

    void* d;
    CUDA_SAFE_CALL(cudaMalloc((void **) &d, recCount*float_size));
    thrust::device_ptr<char> dd((char*)d);
    thrust::fill(dd, dd+source_len,0);

    if (tp == 0) {
        compress_functor_int ff((int_type*)source,(unsigned long long int*)d, (long long int*)s_v, (unsigned int*)d_v);
        thrust::for_each(begin, begin + recCount, ff);
    }
    else {
        compress_functor_float ff((long long int*)source,(unsigned long long int*)d, (long long int*)s_v, (unsigned int*)d_v);
        thrust::for_each(begin, begin + recCount, ff);
    };


    thrust::device_ptr<unsigned long long int> s_copy1((unsigned long long int*)d);

    // make an addition  sequence
    thrust::device_ptr<unsigned int> add_seq = thrust::device_malloc<unsigned int>(recCount);
    thrust::constant_iterator<unsigned int> iter(fit_count);
    thrust::sequence(add_seq, add_seq + recCount, 0, 1);
    thrust::transform(add_seq, add_seq + recCount, iter, add_seq, thrust::divides<unsigned int>());

    unsigned int cnt = (recCount)/fit_count;	
	if(cnt == 0)
	    cnt = 1; // need at least 1
	
    if (recCount%fit_count > 0)
        cnt++;

    //thrust::device_ptr<unsigned long long int> fin_seq = thrust::device_malloc<unsigned long long int>(cnt);
    thrust::device_ptr<unsigned long long int> fin_seq((unsigned long long int*)source);

    thrust::reduce_by_key(add_seq, add_seq+recCount,s_copy1,thrust::make_discard_iterator(),
                          fin_seq);

    // copy fin_seq to host
    unsigned long long int * raw_src = thrust::raw_pointer_cast(fin_seq);

    if(file_name) {
	    cout << "writing " << cnt << endl;
        cudaMemcpy( host.data(), (void *)raw_src, cnt*8, cudaMemcpyDeviceToHost);
        fstream binary_file(file_name,ios::out|ios::binary|ios::app);
        binary_file.write((char *)&cnt, 4);
        binary_file.write((char *)&orig_lower_val, 8);
        binary_file.write((char *)&orig_upper_val, 8);
        binary_file.write((char *)host.data(),cnt*8);
        binary_file.write((char *)&comp_type, 4);
        binary_file.write((char *)&cnt, 4);
        binary_file.write((char *)&recCount, 4);
        binary_file.write((char *)&bits, 4);
        binary_file.write((char *)&orig_lower_val, 8);
        binary_file.write((char *)&fit_count, 4);
        binary_file.write((char *)&start_val, 8);
        binary_file.write((char *)&comp_type, 4);
        binary_file.write((char *)&comp_type, 4); //filler
        binary_file.close();
    }
    else {
        char* hh;
        // resize host to sz + cnt*8 + 15
        host.resize(sz+cnt+8);
        hh = (char*)(host.data() + sz);
        ((unsigned int*)hh)[0] = cnt;
        ((long long int*)(hh+4))[0] = orig_lower_val;
        ((long long int*)(hh+12))[0] = orig_upper_val;
        cudaMemcpy( hh + 20, (void *)raw_src, cnt*8, cudaMemcpyDeviceToHost);
        ((unsigned int*)hh)[5+cnt*2] = comp_type;
        ((unsigned int*)hh)[6+cnt*2] = cnt;
        ((unsigned int*)hh)[7+cnt*2] = recCount;
        ((unsigned int*)hh)[8+cnt*2] = bits;
        ((long long int*)(hh+36+cnt*8))[0] = orig_lower_val;
        ((unsigned int*)hh)[11+cnt*2] = fit_count;
        ((long long int*)(hh+48+cnt*8))[0] = start_val;
        ((unsigned int*)hh)[14+cnt*2] = comp_type;
    };

    thrust::device_free(add_seq);
    cudaFree(d);
    cudaFree(d_v);
    cudaFree(s_v);
    return sz + cnt + 8;
}