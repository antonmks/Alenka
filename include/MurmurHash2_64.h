#ifndef MURMURHASH2_64_H_
#define MURMURHASH2_64_H_

#include <stdint.h>
#include <string.h>

namespace alenka {

#ifdef _WIN64
typedef unsigned __int64 uint64_t;
#endif

uint64_t MurmurHash64S(const void * key, int len, unsigned int seed, unsigned int step, size_t count);
uint64_t MurmurHash64A(const void * key, int len, unsigned int seed);
uint64_t MurmurHash64B(const void * key, int len, unsigned int seed);

} // namespace alenka

#endif /* MURMURHASH2_64_H_ */
