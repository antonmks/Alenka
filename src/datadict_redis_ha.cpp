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

#include "datadict_redis_ha.h"
#include "log.h"

namespace alenka {

DataDictRedisHA::DataDictRedisHA(const std::string& sentinel_host, const std::string& master_name, unsigned int sentinel_port, bool pool): _is_pool_conn(pool){
	 _pool = connection_pool::create_timeout(sentinel_host, master_name, sentinel_port, 0, 500000); //0 sec + 500000 usec [0.5 sec] timeout
	 print_datadict();
}

void DataDictRedisHA::save(){
	//perform background save to disk- optional!
	connection::ptr_t c = _pool->get(connection::MASTER);
	c->run(command("BGSAVE")); // also see 'SAVE' for sync save
	if(_is_pool_conn)
		_pool->put(c);
}

vector<string> DataDictRedisHA::get_tables(){
	connection::ptr_t c = _pool->get(connection::MASTER);
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

bool DataDictRedisHA::table_exist(string table_name){
	connection::ptr_t c = _pool->get(connection::MASTER);
	reply r = c->run(command("SISMEMBER")("tables") << table_name);
	if(_is_pool_conn)
		_pool->put(c);
	return (r.integer() == 1) ? true : false;
}

void DataDictRedisHA::remove_table(string table_name){
	connection::ptr_t c = _pool->get(connection::MASTER);
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

map<string, col_data> DataDictRedisHA::get_columns(string table_name){
	connection::ptr_t c = _pool->get(connection::MASTER);
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

unsigned int DataDictRedisHA::get_column_type(string table_name, string column){
	connection::ptr_t c = _pool->get(connection::MASTER);
	reply r = c->run(command("HGET") << "col:" + table_name + ":" + column << "type");
	if(_is_pool_conn)
		_pool->put(c);
	return stoul(r.str(), nullptr, 0);
}

unsigned int DataDictRedisHA::get_column_length(string table_name, string column){
	connection::ptr_t c = _pool->get(connection::MASTER);
	reply r = c->run(command("HGET") << "col:" + table_name + ":" + column << "length");
	if(_is_pool_conn)
		_pool->put(c);
	return stoul(r.str(), nullptr, 0);
}

void DataDictRedisHA::set_column_type(string table_name, string column, unsigned int type){
	connection::ptr_t c = _pool->get(connection::MASTER);
	c->run(command("MULTI")); //transaction
	c->run(command("HSET") << "col:" + table_name + ":" + column << "type" << type);
	c->run(command("SADD") << "cols:" + table_name << column);
	c->run(command("SADD") << "tables" << table_name);
	c->run(command("EXEC"));
	if(_is_pool_conn)
		_pool->put(c);
}

void DataDictRedisHA::set_column_length(string table_name, string column, unsigned int length){
	connection::ptr_t c = _pool->get(connection::MASTER);
	c->run(command("MULTI")); //transaction
	c->run(command("HSET") << "col:" + table_name + ":" + column << "length" << length);
	c->run(command("SADD") << "cols:" + table_name << column);
	c->run(command("SADD") << "tables" << table_name);
	c->run(command("EXEC"));
	if(_is_pool_conn)
		_pool->put(c);
}

void DataDictRedisHA::print_datadict(){
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
