/*
 * Row call back:
 *      A modular call back for the display verb
 *      hacked by Randolph 2014
 *
 * Note:
 *      This neds to be in C and a seperate file to stay modular
 */

#ifdef __cplusplus
extern "C" {
#endif

extern char alenka_err[4048];

extern int row_cb(void *NotUsed, int field_count, char **fields, char **ColNames);

#ifdef __cplusplus
}
#endif
