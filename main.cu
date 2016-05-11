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

#include <map>
#include <string>
#include <iostream>
#include <ctime>
#include <thrust/device_vector.h>
#include "moderngpu/src/moderngpu/kernel_reduce.hxx"
#include "moderngpu/src/moderngpu/kernel_segreduce.hxx"

using namespace std;
#include "alenka.h"

int main(int ac, char **av)
{
    std::clock_t start;
    int x;

    if(ac < 2) {
        cout << "Usage : alenka [--QPS-test] | [ [-l load size(MB)] [-v] script.sql ]" << endl;
        exit(1);	
    }
    // test QPS via alenkaExecute	-- this section is the only C++ dependency
    else if (string(av[1]) == "--QPS-test") {
        alenkaInit(NULL);
        start = std::clock();
        for (x=0; x< 1000; x++)  {
            alenkaExecute("A1 := SELECT  count(n_name) AS col1 FROM nation;\n DISPLAY A1 USING ('|');");
        }
        cout<< "Ave QPS is : " <<  ( 1000/ (( std::clock() - start ) / (double)CLOCKS_PER_SEC )) << endl;
        alenkaClose();
    }
    else {				// ordinary alenka file mode
        cout << "Executing file:" << endl;
	return execute_file( ac, av) ;
    }
}


