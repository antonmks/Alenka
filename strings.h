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

/// ======================================== H File =================================================
//---------------------------------------------------------------------------
#pragma once
#ifndef STRINGS_H
#define STRINGS_H
//---------------------------------------------------------------------------
#include "cm.h"
//---------------------------------------------------------------------------

#define UNROLL_COUNT 101

/**
* JOIN on host static strings
* @param d_int - the input array of indices of joining strings.
* @param real_count - the input length of the input array indices.
* @param d - the input array of strings that will are joined.
* @param d_char - the output array of joined strings.
* @param len - the input length of string.
*/
void str_gather_host(const unsigned int* d_int, size_t real_count, void* d, void* d_char, unsigned int len);
void str_scatter_host(const unsigned int* d_int, size_t real_count, void* d, void* d_char, unsigned int len);

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

//---------------------------------------------------------------------------
#endif	/// STRINGS_H