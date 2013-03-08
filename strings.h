#include "cm.h"

void str_gather_host(unsigned int* d_int, unsigned int real_count, void* d, void* d_char, unsigned int len);
void str_gather(void* d_int, unsigned int real_count, void* d, void* d_char, const unsigned int len);
void str_sort_host(char* tmp, unsigned int RecCount, unsigned int* permutation, bool srt, unsigned int len);
void str_sort(char* tmp, unsigned int RecCount, unsigned int* permutation, bool srt, unsigned int len);
void str_grp(char* d_char, unsigned int real_count, thrust::device_ptr<bool>& d_group, unsigned int len);
void str_copy_if(char* source, unsigned int mRecCount, char* dest, thrust::device_ptr<bool>& d_grp, unsigned int len);