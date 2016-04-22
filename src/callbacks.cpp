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

#include "callbacks.h"

namespace alenka {

int row_cb(int field_count, char **fields, char **ColName) {
	int i;
	char tab = ' ';
	for(i = 0; i < field_count; i++) {
		printf("|%s%c", fields[i] ? fields[i] : "NULL", tab);
	tab = '\t';	// dont stall the x86 pipeline with an if statement...
	}
	printf("|\n");
	return 0;
}

void error_cb(int severity, const char * err) {
	printf("%s\n", err);
	if (severity >1)
	exit(1);
}

} // namespace alenka
