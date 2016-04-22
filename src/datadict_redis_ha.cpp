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

namespace alenka {

DataDictRedisHA::DataDictRedisHA(const std::string& sentinel_host,  const std::string& master_name, unsigned int sentinel_port){
	 _pool = connection_pool::create_timeout(sentinel_host, master_name, sentinel_port, 0, 500000); //0 sec + 500000 usec [0.5 sec] timeout
}

void DataDictRedisHA::save(){
	//perform background save to disk- optional!
	connection::ptr_t c = _pool->get(connection::MASTER);
	c->run(command("BGSAVE")); // also see 'SAVE' for sync save
}

vector<string> DataDictRedisHA::get_tables(){
	connection::ptr_t c = _pool->get(connection::MASTER);
	reply r = c->run(command("SMEMBERS")("tables"));
}

bool DataDictRedisHA::table_exist(string table_name){
	connection::ptr_t c = _pool->get(connection::MASTER);
	reply r = c->run(command("SISMEMBER")("tables") << table_name);
}

void DataDictRedisHA::remove_table(string table_name){
	connection::ptr_t c = _pool->get(connection::MASTER);
	reply r = c->run(command("SREM")("tables") << table_name);

	 r = c->run(command("HDEL")<< "table:" + table_name << "type");
	 r = c->run(command("HDEL")<< "table:" + table_name << "length");
}

map<string, col_data> DataDictRedisHA::get_columns(string table_name){
	connection::ptr_t c = _pool->get(connection::MASTER);
	reply r = c->run(command("HGETALL") << "table:" + table_name);

}

unsigned int DataDictRedisHA::get_column_type(string table_name, string column){
	connection::ptr_t c = _pool->get(connection::MASTER);
	reply r = c->run(command("HGET") << "table:" + table_name << column << "type");
}

unsigned int DataDictRedisHA::get_column_length(string table_name, string column){
	connection::ptr_t c = _pool->get(connection::MASTER);
	reply r = c->run(command("HSET") << "table:" + table_name << column << "length");
}

void DataDictRedisHA::set_column_type(string table_name, string column, unsigned int type){
	connection::ptr_t c = _pool->get(connection::MASTER);
	reply r = c->run(command("HSET") << "table:" + table_name << column << "type" << type);

	r = c->run(command("SADD") << table_name);
}

void DataDictRedisHA::set_column_length(string table_name, string column, unsigned int length){
	connection::ptr_t c = _pool->get(connection::MASTER);
	reply r = c->run(command("HSET") << "table:" + table_name << column << "length" << length);

	r = c->run(command("SADD") << table_name);

}

} // namespace alenka
