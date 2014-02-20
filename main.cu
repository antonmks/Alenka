/*
 	Example main routine for Alenka
*/

#include "alenka.h"
#include <iostream>
using std::cout;
using std::endl;

int main(int ac, char **av)
{

    if (ac < 2) {
        cout << "Usage : alenka [-l process_count] [-v] script.sql" << endl;
        exit(1);
    }
	else {

		return execute_file( ac, av) ;
	};	
}


