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

#ifndef IDATADICT_H_
#define IDATADICT_H_

#include <map>
#include <vector>

using namespace std;

namespace alenka {

struct col_data {
	unsigned int col_type;
	unsigned int col_length;
};

class IDataDict
{
    public:
        virtual ~IDataDict() {}
        virtual void save() = 0;
        virtual vector<string> get_tables() = 0;
        virtual bool table_exist(string table_name) = 0;
        virtual void remove_table(string table_name) = 0;
        virtual map<string, col_data> get_columns(string table_name) = 0;
        virtual unsigned int get_column_type(string table_name, string column) = 0;
        virtual unsigned int get_column_length(string table_name, string column) = 0;
        virtual void set_column_type(string table_name, string column, unsigned int type) = 0;
        virtual void set_column_length(string table_name, string column, unsigned int length) = 0;
};

} // namespace alenka

#endif /* IDATADICT_H_ */
