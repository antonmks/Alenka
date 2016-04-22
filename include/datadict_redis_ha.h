#ifndef DATADICT_REDIS_HA_H_
#define DATADICT_REDIS_HA_H_

#include "idatadict.h"

#include <redis3m/redis3m.hpp>

using namespace redis3m;

namespace alenka {

class DataDictRedisHA: public IDataDict {
public:
	DataDictRedisHA(const std::string& sentinel_host,  const std::string& master_name, unsigned int sentinel_port);
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
	connection_pool::ptr_t _pool;
};

} // namespace alenka




#endif /* DATADICT_REDIS_HA_H_ */
