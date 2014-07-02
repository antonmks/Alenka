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

//
// ---------------------------------------------------
// File:     	callbacks.cu
// Purpose:  	call back to deliver rows and errors
// Author:   	Randolph
// Date:     	May 2014
// ---------------------------------------------------
//

#include <stdio.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

//char alenka_err[4048];

//
//  Row call back:
//  	A modular call back for the display verb
//  	Inspired by sqlite3
//  	Hacked by Randolph 2014
// 	Usage:
// 		Replace this routine with your own output method. The Display verb will call it.
//
extern int row_cb(int field_count, char **fields, char **ColName){
   int i;
   char tab=' ';
   for(i=0; i<field_count; i++){
      	printf("|%s%c", fields[i] ? fields[i] : "NULL", tab);
	tab = '\t';	// dont stall the x86 pipeline with an if statement...
   }
   printf("|\n");
   return 0;
}

//
// Error callback:
// 	A modular callback for all errors
// 	replace with a method of your own
//
void
error_cb(int severity, const char * err) {
    printf("%s\n", err);
    if (severity >1)
	exit(1);
}
#ifdef __cplusplus
}
#endif
