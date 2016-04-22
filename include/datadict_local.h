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

#ifndef DATADICT_LOCAL_H_
#define DATADICT_LOCAL_H_

#include "idatadict.h"

using namespace std;

namespace alenka {

class DataDictLocal: public IDataDict {
public:
	DataDictLocal(string file_name);
	void save();
	vector<string> get_tables();
	bool table_exist(string table_name);
	void remove_table(string table_name);
	map<string, col_data> get_columns(string table_name);
	unsigned int get_column_type(string table_name, string column);
	unsigned int get_column_length(string table_name, string column);
	void set_column_type(string table_name, string column, unsigned int type);
	void set_column_length(string table_name, string column, unsigned int length);
private:
	void load_col_data(map<string, map<string, col_data> >& data_dict, string file_name);
	void save_col_data(map<string, map<string, col_data> >& data_dict, string file_name);
	map<string, map<string, col_data> > _data_dict;
	string _file_name;
};

} // namespace alenka

#endif /* DATADICT_LOCAL_H_ */
