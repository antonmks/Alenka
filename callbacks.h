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
// File:	callbacks.h
// Purpose:	callback code for row and error delivery
// Author:	Randolph
// Date:	May 2014
// ---------------------------------------------------
//

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Row call back:
 *      A modular call back for the display verb
 *      This neds to be in C and a seperate file to stay modular
 */
extern int row_cb(int field_count, char **fields, char **ColNames);

void error_cb(int severity, const char * err);
#ifdef __cplusplus
}
#endif
