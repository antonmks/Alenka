/*
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#ifndef FILTER_CUH_
#define FILTER_CUH_

namespace alenka {

struct cmp_functor_dict {
    const unsigned long long* source;
    bool *dest;
    const unsigned int *pars;

    cmp_functor_dict(const unsigned long long int* _source, bool * _dest,  const unsigned int * _pars):
        source(_source), dest(_dest), pars(_pars) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        unsigned int idx = pars[0];
        unsigned int cmp = pars[1];
        unsigned int bits = ((unsigned int*)source)[1];
        unsigned int fit_count = ((unsigned int*)source)[0];
        unsigned int int_sz = 64;

        //find the source index
        unsigned int src_idx = i/fit_count;
        // find the exact location
        unsigned int src_loc = i%fit_count;
        //right shift the values
        unsigned int shifted = ((fit_count-src_loc)-1)*bits;
        unsigned long long int tmp = source[src_idx+2]  >> shifted;
        // set  the rest of bits to 0
        tmp	= tmp << (int_sz - bits);
        tmp	= tmp >> (int_sz - bits);
        //printf("COMP1 %llu %d \n", tmp, idx);
        if (cmp == 4) { // ==
            if (tmp == idx)
                dest[i] = 1;
            else
                dest[i] = 0;
        } else { // !=
            if (tmp == idx)
                dest[i] = 0;
            else
                dest[i] = 1;
        }
    }
};

struct gpu_regex {
    char *source;
    char *pattern;
    bool * dest;
    const unsigned int *len;

    gpu_regex(char * _source, char * _pattern, bool * _dest, const unsigned int * _len):
        source(_source), pattern(_pattern), dest(_dest), len(_len) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        bool star = 0;
        int j = 0;
        char* s;
        char* p;
        char* str = source + len[0]*i;
        char* pat = pattern;

loopStart:
        for (s = str, p = pat; j < len[0] && *s; ++s, ++p, ++j) {
            switch (*p) {
            case '?':
                if (*s == '.') goto starCheck;
                break;
            case '%':
                star = 1;
                str = s, pat = p;
                do {
                    ++pat;
                } while (*pat == '%');
                if (!*pat) {
                    dest[i] = 1;
                    return;
                }
                goto loopStart;
            default:
                if (*s != *p)
                    goto starCheck;
                break;
            } /* endswitch */
        } /* endfor */
        while (*p == '%') ++p;
        dest[i] = !*p;
        return;

starCheck:
        if (!star) {
            dest[i] = 0;
            return;
        }
        str++;
        j++;
        goto loopStart;
    }
};

} // namespace alenka

#endif /* FILTER_CUH_ */
