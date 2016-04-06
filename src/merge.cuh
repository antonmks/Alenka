/*
 * merge.cuh
 *
 *  Created on: Apr 5, 2016
 *      Author: user
 */

#ifndef MERGE_CUH_
#define MERGE_CUH_

#include "types.h"

struct float_avg
{
    __host__
    float_type operator()(const float_type &lhs, const int_type &rhs) const {
        return lhs/rhs;
    }
};

struct float_avg1
{
    __host__
    float_type operator()(const int_type &lhs, const int_type &rhs) const {
        return ((float_type)lhs)/rhs;
    }
};

struct div100
{
    __host__
    int_type operator()(const int_type &lhs, const int_type &rhs) const {
        return (lhs*100)/rhs;
    }
};



#endif /* MERGE_CUH_ */
