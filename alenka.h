/*
*
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
// File:	Alenka.h
// Purpose:	The list of supported alenka lib calls
// Author:	Randolph 
// Date:	14/2/14
// ---------------------------------------------------
//



#ifdef __cplusplus		// If c++ then expose data.dict structure and calls
//------------------------------------------------------------------------------------------
#include <map>

struct col_data {
        unsigned int col_type;
        unsigned int col_length;
};

extern map<string, map<string, col_data> > data_dict;
extern void load_col_data(map<string, map<string, col_data> >& data_dict, string file_name);
//------------------------------------------------------------------------------------------
#endif



// call:
void alenkaInit(char ** av);
int alenkaExecute(char *s);
void alenkaClose();

// or:
int execute_file(int ac, char **av);


