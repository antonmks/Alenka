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

//
// ---------------------------------------------------
// File:	callbacks.h
// Purpose:	callback code for row and error delivery
// Author:	Randolph
// Date:	May 2014
// ---------------------------------------------------
//

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Row call back:
 *      A modular call back for the display verb
 *      This neds to be in C and a seperate file to stay modular
 */
extern int row_cb(int field_count, char **fields, char **ColNames);

void error_cb(int severity, const char * err);
#ifdef __cplusplus
}
#endif
