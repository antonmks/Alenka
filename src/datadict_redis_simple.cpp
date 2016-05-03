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

#include "datadict_redis_simple.h"
#include "log.h"

namespace alenka {

DataDictRedisSimple::DataDictRedisSimple(const std::string& host, unsigned int port, bool pool) : _is_pool_conn(pool), _pool(simple_pool::create(host, port)){
	print_datadict();
}

DataDictRedisSimple::DataDictRedisSimple(const std::string& path, bool pool) : _is_pool_conn(pool), _pool(simple_pool::create(path)){
	print_datadict();
}

void DataDictRedisSimple::save(){
	//perform background save to disk- optional!
	connection::ptr_t c = _pool->get();
	c->run(command("BGSAVE")); // also see 'SAVE' for sync save
	if(_is_pool_conn)
		_pool->put(c);
}

vector<string> DataDictRedisSimple::get_tables(){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("SMEMBERS")("tables"));
	vector<string> tables;
	vector<reply> elements = r.elements();
	for (auto it=elements.begin() ; it != elements.end(); ++it) {
		string table = (*it).str();
		tables.push_back(table);
	}
	if(_is_pool_conn)
		_pool->put(c);
	return tables;
}

bool DataDictRedisSimple::table_exist(string table_name){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("SISMEMBER")("tables") << table_name);
	if(_is_pool_conn)
		_pool->put(c);
	return (r.integer() == 1) ? true : false;
}

void DataDictRedisSimple::remove_table(string table_name){
	connection::ptr_t c = _pool->get();
	//transaction
	c->run(command("MULTI"));
	c->run(command("SREM")("tables") << table_name);
	c->run(command("DEL") << "cols:" + table_name);
	map<string, col_data> cols = get_columns(table_name);
	for (auto cit = cols.begin() ; cit != cols.end() ; ++cit) {
		c->run(command("DEL") << "col:" + table_name + ":" + (*cit).first);
	}
	c->run(command("EXEC"));
	if(_is_pool_conn)
		_pool->put(c);
}

map<string, col_data> DataDictRedisSimple::get_columns(string table_name){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("SMEMBERS") << "cols:" + table_name);
	map<string, col_data> columns;
	vector<reply> elements = r.elements();
	for (auto it=elements.begin() ; it != elements.end(); ++it) {
		string col = (*it).str();
		columns[col].col_type = get_column_type(table_name, col);
		columns[col].col_length = get_column_length(table_name, col);
	}
	if(_is_pool_conn)
		_pool->put(c);
	return columns;
}

unsigned int DataDictRedisSimple::get_column_type(string table_name, string column){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("HGET") << "col:" + table_name + ":" + column << "type");
	if(_is_pool_conn)
		_pool->put(c);
	return stoul(r.str(), nullptr, 0);
}

unsigned int DataDictRedisSimple::get_column_length(string table_name, string column){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("HGET") << "col:" + table_name + ":" + column << "length");
	if(_is_pool_conn)
		_pool->put(c);
	return stoul(r.str(), nullptr, 0);
}

void DataDictRedisSimple::set_column_type(string table_name, string column, unsigned int type){
	connection::ptr_t c = _pool->get();
	c->run(command("MULTI")); //transaction
	c->run(command("HSET") << "col:" + table_name + ":" + column << "type" << type);
	c->run(command("SADD") << "cols:" + table_name << column);
	c->run(command("SADD") << "tables" << table_name);
	c->run(command("EXEC"));
	if(_is_pool_conn)
		_pool->put(c);
}

void DataDictRedisSimple::set_column_length(string table_name, string column, unsigned int length){
	connection::ptr_t c = _pool->get();
	c->run(command("MULTI")); //transaction
	c->run(command("HSET") << "col:" + table_name + ":" + column << "length" << length);
	c->run(command("SADD") << "cols:" + table_name << column);
	c->run(command("SADD") << "tables" << table_name);
	c->run(command("EXEC"));
	if(_is_pool_conn)
		_pool->put(c);
}

void DataDictRedisSimple::print_datadict(){
	vector<string> tables = get_tables();
	for (auto it=tables.begin() ; it != tables.end(); ++it) {
		string table = (*it);
		map<string, col_data> c = get_columns(table);
		for (auto cit = c.begin() ; cit != c.end() ; ++cit) {
			 LOG(logDEBUG) << "data DICT " << table << " " << (*cit).first << " " << (*cit).second.col_type << " " << (*cit).second.col_length;
		}
	}
}

} // namespace alenka
