#ifndef CALLBACKS_H_
#define CALLBACKS_H_


#include <stdlib.h>
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

void row_cb(int field_count, char **fields, char **ColNames);
void error_cb(int severity, const char * err);

#ifdef __cplusplus
}
#endif

#endif /* CALLBACKS_H_ */
