/*
 * Row call back:
 * 	A modular call back for the display verb
 * 	hacked by Randolph 2014
 *
 * Note:
 * 	This neds to be in C and a seperate file to stay modular
 */

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

char alenka_err[4048];

extern int row_cb(void *NotUsed, int field_count, char **fields, char **ColName){
   int i;
   for(i=0; i<field_count; i++){
      printf("\t| %s", ColName[i], fields[i] ? fields[i] : "NULL");
   }
   printf("\t|\n");
   return 0;
}

#ifdef __cplusplus
}
#endif
