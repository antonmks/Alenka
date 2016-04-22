#ifndef DATADICT_REDIS_SIMPLE_H_
#define DATADICT_REDIS_SIMPLE_H_

#include "idatadict.h"

#include <redis3m/redis3m.hpp>

using namespace redis3m;

namespace alenka {

class DataDictRedisSimple: public IDataDict {
public:
	DataDictRedisSimple(const std::string& host, unsigned int port);
	DataDictRedisSimple(const std::string& path);
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
	simple_pool::ptr_t _pool;
};

} // namespace alenka



#endif /* DATADICT_REDIS_SIMPLE_H_ */
