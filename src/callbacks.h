#ifndef CALLBACKS_H_
#define CALLBACKS_H_


#include <stdlib.h>
#include <stdio.h>


void row_cb(int field_count, char **fields, char **ColNames);
void error_cb(int severity, const char * err);


#endif /* CALLBACKS_H_ */
