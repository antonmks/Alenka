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

namespace alenka {

DataDictRedisSimple::DataDictRedisSimple(const std::string& host, unsigned int port){
	  simple_pool::ptr_t pool = simple_pool::create(host, port);
}

DataDictRedisSimple::DataDictRedisSimple(const std::string& path){
	  simple_pool::ptr_t pool = simple_pool::create(path);
}

void DataDictRedisSimple::save(){
	//perform background save to disk- optional!
	connection::ptr_t c = _pool->get();
	c->run(command("BGSAVE")); // also see 'SAVE' for sync save
}

vector<string> DataDictRedisSimple::get_tables(){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("SMEMBERS")("tables"));
}

bool DataDictRedisSimple::table_exist(string table_name){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("SISMEMBER")("tables") << table_name);
}

void DataDictRedisSimple::remove_table(string table_name){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("SREM")("tables") << table_name);

	 r = c->run(command("HDEL")<< "table:" + table_name << "type");
	 r = c->run(command("HDEL")<< "table:" + table_name << "length");
}

map<string, col_data> DataDictRedisSimple::get_columns(string table_name){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("HGETALL") << "table:" + table_name);

}

unsigned int DataDictRedisSimple::get_column_type(string table_name, string column){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("HGET") << "table:" + table_name << column << "type");

}

unsigned int DataDictRedisSimple::get_column_length(string table_name, string column){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("HSET") << "table:" + table_name << column << "length");

}

void DataDictRedisSimple::set_column_type(string table_name, string column, unsigned int type){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("HSET") << "table:" + table_name << column << "type" << type);

	r = c->run(command("SADD") << table_name);
}

void DataDictRedisSimple::set_column_length(string table_name, string column, unsigned int length){
	connection::ptr_t c = _pool->get();
	reply r = c->run(command("HSET") << "table:" + table_name << column << "length" << length);

	r = c->run(command("SADD") << table_name);
}

} // namespace alenka
