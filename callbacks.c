/*
 * Note:
 * 	This needs to be in C and a seperate file to stay modular
 *
 * 	Usage:
 * 		Replace this routine with your own output method. The Display verb will call it.
 */

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
// 	A modular callbac for all errors
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
