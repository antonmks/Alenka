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

#ifndef CUDA_SAFE_H_
#define CUDA_SAFE_H_

namespace alenka {

#  define CUDA_SAFE_CALL_NO_SYNC(call) do {                                  \
    cudaError err = call;                                                    \
    if ( cudaSuccess != err) {                                                \
        fprintf(stderr, "Cuda error in file '%s' in line %i : %s.\n",        \
                __FILE__, __LINE__, cudaGetErrorString(err));                \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)
#  define CUDA_SAFE_CALL(call) do {                                          \
    CUDA_SAFE_CALL_NO_SYNC(call);                                            \
    cudaError err = cudaThreadSynchronize();                                 \
    if ( cudaSuccess != err) {                                                \
        fprintf(stderr, "Cuda error in file '%s' in line %i : %s.\n",        \
                __FILE__, __LINE__, cudaGetErrorString(err));                \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

} // namespace alenka

#endif /* CUDA_SAFE_H_ */
