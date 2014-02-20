/*
 * Row call back:
 * 	A modular call back for the display verb
 * 	Inspired by sqlite3
 * 	Hacked by Randolph 2014
 *
 * Note:
 * 	This needs to be in C and a seperate file to stay modular
 *
 * 	Usage:
 * 		Replace this routine with your own output method. The Display verb will call it.
 */

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

char alenka_err[4048];

extern int row_cb(void *NotUsed, int field_count, char **fields, char **ColName){
   int i;
   char tab=' ';
   for(i=0; i<field_count; i++){
      	printf("|%s%c", fields[i] ? fields[i] : "NULL", tab);
	tab = '\t';	// dont stall the x86 pipeline with an if statement...
   }
   printf("|\n");
   return 0;
}

#ifdef __cplusplus
}
#endif
