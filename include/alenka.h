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

#ifndef ALENKA_H_
#define ALENKA_H_

#include "log.h"

using namespace std;

namespace alenka {

//config
extern string data_dict_local_name;
extern string data_dict_redis_simple_host;
extern unsigned int data_dict_redis_simple_port;
extern bool data_dict_redis_simple_pool;
extern string data_dict_redis_ha_sentinel_host;
extern string data_dict_redis_ha_master_name;
extern unsigned int ata_dict_redis_ha_sentinel_port;
extern bool data_dict_redis_ha_pool;
extern const char* file_system_local_base_path;
extern const char* file_system_hdfs_host;
extern unsigned int file_system_hdfs_port;
extern const char* file_system_hdfs_base_path;

// call:
void init(char ** av);
int execute(char *s);
void close();

// or:
int execute_file(int ac, char **av);

} // namespace alenka

#endif /* ALENKA_H_ */
