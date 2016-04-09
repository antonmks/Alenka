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

#ifndef CALLBACKS_H_
#define CALLBACKS_H_

#include <stdlib.h>
#include <stdio.h>

namespace alenka {

int row_cb(int field_count, char **fields, char **ColNames);
void error_cb(int severity, const char * err);

}
#endif /* CALLBACKS_H_ */
