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

#include <iostream>
#include <ctime>
#include <string>

#include "alenka.h"

using namespace std;

int main(int ac, char **av) {
    std::clock_t start;

    //overwrite config - see global.cu for defaults
    alenka::data_dict_local_name = "alenka.dictonary";

    // test QPS via alenka::execute
    if (ac == 2 && string(av[1]) == "--QPS-test") {
    	alenka::init(NULL);
        start = std::clock();
        for (int x=0; x< 1000; x++)  {
        	alenka::execute("A1 := SELECT  count(n_name) AS col1 FROM nation;\n DISPLAY A1 USING ('|');");
        }
        cout << "Ave QPS is : " <<  (1000/ ((std::clock() - start) / (double)CLOCKS_PER_SEC)) << endl;
        alenka::close();
    } else {  // ordinary alenka::execute_file file mode
        if (ac < 2) {
            cerr << "Usage : alenka [--QPS-test] | [ [-l load size(MB)] [-v] script.sql ]" << endl;
            exit(EXIT_FAILURE);
        } else {
            return alenka::execute_file(ac, av);
        }
    }
}


