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

#include <fstream>
#include <vector>
#include <map>

#include "log.h"
#include "datadict_local.h"

namespace alenka {

DataDictLocal::DataDictLocal(string file_name): _file_name(file_name){
	load_col_data(_data_dict, file_name);
}

void DataDictLocal::save(){
	save_col_data(_data_dict, _file_name);
}

vector<string> DataDictLocal::get_tables(){
	vector<string> tables;
	for (auto it=_data_dict.begin() ; it != _data_dict.end(); ++it) {
		tables.push_back((*it).first);
	}
	return tables;
}

bool DataDictLocal::table_exist(string table_name){
	return _data_dict.count(table_name) > 0 ? true : false;

}
void DataDictLocal::remove_table(string table_name){
	_data_dict.erase(table_name);
}
map<string, col_data> DataDictLocal::get_columns(string table_name){
	return _data_dict[table_name];
}
unsigned int DataDictLocal::get_column_type(string table_name, string column){
	return _data_dict[table_name][column].col_type;
}
unsigned int DataDictLocal::get_column_length(string table_name, string column){
	return _data_dict[table_name][column].col_length;
}
void DataDictLocal::set_column_type(string table_name, string column, unsigned int type){
	 _data_dict[table_name][column].col_type = type;
}
void DataDictLocal::set_column_length(string table_name, string column, unsigned int length){
	_data_dict[table_name][column].col_length = length;
}

void DataDictLocal::load_col_data(map<string, map<string, col_data> >& data_dict, string file_name) {
    size_t str_len, recs, len1;
    string str1, str2;
    char buffer[4000];
    unsigned int col_type, col_length;
    fstream binary_file;
    binary_file.open(file_name.c_str(), ios::in|ios::binary);
    if (binary_file.is_open()) {
        binary_file.read((char*)&recs, 8);
        for (unsigned int i = 0; i < recs; i++) {
            binary_file.read((char*)&str_len, 8);
            binary_file.read(buffer, str_len);
            str1.assign(buffer, str_len);
            binary_file.read((char*)&len1, 8);

            for (unsigned int j = 0; j < len1; j++) {
                binary_file.read((char*)&str_len, 8);
                binary_file.read(buffer, str_len);
                str2.assign(buffer, str_len);
                binary_file.read((char*)&col_type, 4);
                binary_file.read((char*)&col_length, 4);
                data_dict[str1][str2].col_type = col_type;
                data_dict[str1][str2].col_length = col_length;
                LOG(logDEBUG) << "data DICT " << str1 << " " << str2 << " " << col_type << " " << col_length;
            }
        }
        binary_file.close();
    } else {
    	LOG(logWARNING) << "Couldn't open data dictionary";
    }
}

void DataDictLocal::save_col_data(map<string, map<string, col_data> >& data_dict, string file_name) {
    size_t str_len;
    fstream binary_file(file_name.c_str(), ios::out|ios::binary|ios::trunc);
    size_t len = data_dict.size();
    binary_file.write((char *)&len, 8);
    for (auto it=data_dict.begin() ; it != data_dict.end(); ++it) {
        str_len = (*it).first.size();
        binary_file.write((char *)&str_len, 8);
        binary_file.write((char *)(*it).first.data(), str_len);
        map<string, col_data> s = (*it).second;
        size_t len1 = s.size();
        binary_file.write((char *)&len1, 8);

        for (auto sit = s.begin() ; sit != s.end() ; ++sit) {
            str_len = (*sit).first.size();
            binary_file.write((char *)&str_len, 8);
            binary_file.write((char *)(*sit).first.data(), str_len);
            binary_file.write((char *)&(*sit).second.col_type, 4);
            binary_file.write((char *)&(*sit).second.col_length, 4);
        }
    }
    binary_file.close();
}

} // namespace alenka
