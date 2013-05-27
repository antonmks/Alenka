/// ======================================== H File =================================================
//---------------------------------------------------------------------------
#pragma once
#ifndef STRINGS_H
#define STRINGS_H
//---------------------------------------------------------------------------
#include <thrust/device_ptr.h>
#include "cm.h"
//---------------------------------------------------------------------------
/**
* JOIN on host static strings
* @param d_int - the input array of indices of joining strings.
* @param real_count - the input length of the input array indices.
* @param d - the input array of strings that will are joined.
* @param d_char - the output array of joined strings.
* @param len - the input length of string.
*/
void str_gather_host(unsigned int* d_int, size_t real_count, void* d, void* d_char, unsigned int len);

/**
* JOIN on device static strings
* @param d_int - the input array of indices of joining strings.
* @param real_count - the input length of the input array indices.
* @param d - the input array of strings that will are joined.
* @param d_char - the output array of joined strings.
* @param len - the input length of string.
*/
void str_gather(void* d_int, size_t real_count, void* d, void* d_char, const unsigned int len);

/**
*  SORT on host indices by static strings
* @param tmp - the input array of sorting strings.
* @param RecCount - the input length of the input array strings.
* @param permutation - the output array of sorted indices.
* @param desc_order - true - keys are sorted in descending order, false - keys are sorted in ascending order.
* @param len - the input length of string in bytes.
*/
void str_sort_host(char* tmp, size_t RecCount, unsigned int* permutation, bool desc_order, unsigned int len);

/**
*  SORT on device indices by static strings
* @param tmp - the input array of sorting strings.
* @param RecCount - the input length of the input array strings.
* @param permutation - the output array of sorted indices.
* @param desc_order - true - keys are sorted in descending order, false - keys are sorted in ascending order.
* @param len - the input length of string in bytes.
*/
void str_sort(char* tmp, size_t RecCount, unsigned int* permutation, bool desc_order, unsigned int len);

/// GROUP BY on device static strings - not used now
// void str_grp(char* d_char, size_t real_count, thrust::device_ptr<bool>& d_group, unsigned int len);

/**
*  Filtering on device static strings
* @param source - the input array of filtering strings.
* @param mRecCount - the input length of the input array strings.
* @param dest - the output array of filtered strings.
* @param d_grp - the input array of the flags (stencil), true do copy, false don't.
* @param len - the input length of string in bytes.
*/
void str_copy_if(char* source, size_t mRecCount, char* dest, thrust::device_ptr<bool>& d_grp, unsigned int len);

//---------------------------------------------------------------------------
#endif	/// STRINGS_H