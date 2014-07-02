/*
*
*    This file is part of Alenka.
*
*    Alenka is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    Alenka is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with Alenka.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <map>
#include <string>
#include <iostream>
#include <ctime>


using namespace std;
#include "alenka.h"

int main(int ac, char **av)
{
    std::clock_t start;
    int x;


    // test QPS via alenkaExecute	-- this section is the only C++ dependency
    if (string(av[1]) == "--QPS-test") {
        alenkaInit(NULL);
        start = std::clock();
        for (x=0; x< 1000; x++)  {
            alenkaExecute("A1 := SELECT  count(n_name) AS col1 FROM nation;\n DISPLAY A1 USING ('|');");
        }
        cout<< "Ave QPS is : " <<  ( 1000/ (( std::clock() - start ) / (double)CLOCKS_PER_SEC )) << endl;
        alenkaClose();
    }
    else {				// ordinary alenka file mode
        if (ac < 2) {
            cout << "Usage : alenka [--QPS-test] | [ [-l process_count] [-v] script.sql ]" << endl;
            exit(1);
        }
        else
            return execute_file( ac, av) ;
    }
}


