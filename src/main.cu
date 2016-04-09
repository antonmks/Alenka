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
using namespace alenka;

int main(int ac, char **av) {
    std::clock_t start;
    int x;
    // test QPS via alenkaExecute	-- this section is the only C++ dependency
    if (ac == 2 && string(av[1]) == "--QPS-test") {
        init(NULL);
        start = std::clock();
        for (x=0; x< 1000; x++)  {
            execute("A1 := SELECT  count(n_name) AS col1 FROM nation;\n DISPLAY A1 USING ('|');");
        }
        LOG(alenka::logINFO) << "Ave QPS is : " <<  (1000/ ((std::clock() - start) / (double)CLOCKS_PER_SEC));
        close();
    } else {  // ordinary alenka file mode
        if (ac < 2) {
            cerr << "Usage : alenka [--QPS-test] | [ [-l load size(MB)] [-v] script.sql ]" << endl;
            exit(EXIT_FAILURE);
        } else {
            return execute_file(ac, av);
        }
    }
}


