/*
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#include "zone_map.h"

void process_error(int severity, string err);   // this should probably live in a utils header file

bool fh_equal_to(const float_type x, const float_type y)
{
    return (((x-y) < EPSILON) && ((x-y) > -EPSILON));
}


bool fh_less(const float_type x, const float_type y)
{
    return ((y-x) > EPSILON);
}


bool fh_greater(const float_type x, const float_type y)
{
    return ((x-y) > EPSILON);
}


bool fh_greater_equal_to(const float_type x, const float_type y)
{
    return (((x-y) > EPSILON) || (((x-y) < EPSILON) && ((x-y) > -EPSILON)));
}


bool fh_less_equal_to(const float_type x, const float_type y)
{
    return (((y-x) > EPSILON) || (((x-y) < EPSILON) && ((x-y) > -EPSILON)));
}

char host_logical_and(char column1, char column2)
{
    LOG(logDEBUG) << "AND " << column1 << " " << column2;
    if (column1 == 'A' && column2 == 'A')
        return 'A';
    else if (column1 == 'N' || column2 == 'N') {
        return 'N';
    }
    else
        return 'R';

}


char host_logical_or(char column1, char column2)
{
	LOG(logDEBUG) << "OR " << column1 << " " << column2;
    if (column1 == 'A' && column2 == 'A')
        return 'A';
    else if (column1 == 'N' && column2 == 'N')
        return 'N';
    else
        return 'R';

}



char host_compare(int_type s, int_type d, int_type op_type)
{
    char res = 'N';

    if (op_type == 2 && d>s ) // >
        res = 'A';
    else if (op_type == 1 && d<s)  // <
        res = 'A';
    else if (op_type == 6 && d>=s) // >=
        res = 'A';
    else if (op_type == 5 && d<=s)  // <=
        res = 'A';
    else if (op_type == 4 && d==s)// =
        res = 'A';
    else // !=
        if(d!=s) res = 'A';

    return res;
}


char host_compare(float_type s, float_type d, int_type op_type)
{
    char res = 'N';

    if (op_type == 2 && (d-s) > EPSILON) // >
        res = 'A';
    else if (op_type == 1 && (s-d) > EPSILON)  // <
        res = 'A';
    else if (op_type == 6 && ((d-s) > EPSILON) || (((d-s) < EPSILON) && ((d-s) > -EPSILON))) // >=
        res = 'A';
    else if (op_type == 5 && ((s-d) > EPSILON) || (((d-s) < EPSILON) && ((d-s) > -EPSILON)))  // <=
        res = 'A';
    else if (op_type == 4 && ((d-s) < EPSILON) && ((d-s) > -EPSILON))// =
        res = 'A';
    else // !=
        if (!(((d-s) < EPSILON) && ((d-s) > -EPSILON))) res = 'A';

    return res;
}


char host_compare(int_type* column1, int_type d, int_type op_type)
{
    char res = 'R';
	
	if (op_type == 2) {   // >
        if (column1[1] <= d)
            res = 'N';
        else if (column1[0] > d)
            res = 'A';
    }
    else if (op_type == 1) { // <
        if (column1[0] >= d)
            res = 'N';
        else if (column1[1] < d)
            res = 'A';
    }
    else if (op_type == 6) {  // >=
        if (column1[1] < d)
            res = 'N';
        else if (column1[0] >= d)
            res = 'A';
    }
    else if (op_type == 5) { // <=
        if (column1[0] > d)
            res = 'N';
        else if (column1[1] <= d)
            res = 'A';
    }
    else if (op_type == 4 && column1[0] == d && column1[1] == d) { // =
        res = 'A';
    };
    LOG(logDEBUG) << "res " << res;

    return res;
}

char host_compare(float_type* column1, float_type d, int_type op_type)
{
    char res = 'R';
    LOG(logDEBUG) << "CMP " << column1[0] << " " << column1[1] << " with " << d << endl;

    if (op_type == 2) { // >
        if(fh_less_equal_to(column1[1],d)) {
            res = 'N';
        }
        else if(fh_greater(column1[0],d)) {
            res = 'A';
        };
    }
    else if (op_type == 1) { // <
        if(fh_less(column1[1],d)) {
            res = 'A';
        }
        else if(fh_greater_equal_to(column1[0],d)) {
            res = 'N';
        };
    }
    else if (op_type == 6) { // >=
        if(fh_greater_equal_to(column1[0],d)) {
            res = 'A';
        }
        else if(fh_less(column1[1],d)) {
            res = 'N';
        };
    }
    else if (op_type == 5) { // <=
        if(fh_less_equal_to(column1[1],d)) {
            res = 'A';
        }
        else if(fh_greater(column1[0],d)) {
            res = 'N';
        };
    }
    else if (op_type == 4 && fh_equal_to(column1[0],d) && fh_equal_to(column1[1],d)) // =
        res = 'A';

    LOG(logDEBUG) << "res " << res << endl;
    return res;

}


char host_compare(int_type* column1, int_type* column2, int_type op_type)
{
    char res = 'R';	
	
    if (op_type == 2) { // >
        if(column1[0] > column2[1])
            res = 'A';
        else if(column1[1] <= column2[0])
            res = 'N';
    }
    else if (op_type == 1) { // <
        if(column1[1] < column2[0])
            res = 'A';
        else if(column1[0] >= column2[1])
            res = 'N';
    }
    else if (op_type == 6) { // >=
        if(column1[0] >= column2[1])
            res = 'A';
        else if(column1[1] < column2[0])
            res = 'N';
    }
    else if (op_type == 5) { // <=
        if(column1[1] <= column2[0])
            res = 'A';
        else if(column1[0] > column2[1])
            res = 'N';
    }
    else if (op_type == 4  && column1[0] == column2[1] && column1[1] == column2[0]) // =
        res = 'A';

    return res;


}

char host_compare(float_type* column1, float_type* column2, int_type op_type)
{
    char res = 'R';

    if (op_type == 2) { // >
        if(fh_greater(column1[0],column2[1]))
            res = 'A';
        else if(fh_less_equal_to(column1[1],column2[0]))
            res = 'N';
    }
    else if (op_type == 1) { // <
        if(fh_less(column1[1],column2[0]))
            res = 'A';
        else if(fh_greater_equal_to(column1[0],column2[1]))
            res = 'N';
    }
    else if (op_type == 6) { // >=
        if(fh_greater_equal_to(column1[1],column2[0]))
            res = 'A';
        else if(fh_less(column1[1],column2[0]))
            res = 'N';
    }
    else if (op_type == 5) { // <=
        if(fh_less_equal_to(column1[1],column2[0]))
            res = 'A';
        else if(fh_greater(column1[0],column2[1]))
            res = 'N';
    }
    else if (op_type == 4  && fh_equal_to(column1[0], column2[1]) && fh_equal_to(column1[1],column2[0])) // =
        res = 'A';

    return res;
}


char host_compare(float_type* column1, int_type* column2, int_type op_type)
{
    char res = 'R';

    if (op_type == 2) { // >
        if(fh_greater(column1[0],(float_type)column2[1]))
            res = 'A';
        else if(fh_less_equal_to(column1[1],(float_type)column2[0]))
            res = 'N';
    }
    else if (op_type == 1) { // <
        if(fh_less(column1[1],(float_type)column2[0]))
            res = 'A';
        else if(fh_greater_equal_to(column1[0],(float_type)column2[1]))
            res = 'N';
    }
    else if (op_type == 6) { // >=
        if(fh_greater_equal_to(column1[1],(float_type)column2[0]))
            res = 'A';
        else if(fh_less(column1[1],(float_type)column2[0]))
            res = 'N';
    }
    else if (op_type == 5) { // <=
        if(fh_less_equal_to(column1[1],(float_type)column2[0]))
            res = 'A';
        else if(fh_greater(column1[0],(float_type)column2[1]))
            res = 'N';
    }
    else if (op_type == 4  && fh_equal_to(column1[0],(float_type) column2[1]) && fh_equal_to(column1[1],(float_type)column2[0])) // =
        res = 'A';

    return res;
}



float_type* host_op(int_type* column1, float_type* column2, string op_type, int reverse)
{

    float_type* temp = (float_type*)malloc(2*float_size);
    temp[0] = (float_type)column1[0];
    temp[1] = (float_type)column1[1];

    if(reverse == 0) {
        if (op_type.compare("MUL") == 0) {
            temp[0] = temp[0] * column2[0];
            temp[1] = temp[1] * column2[1];
        }
        else if (op_type.compare("ADD") == 0) {
            temp[0] = temp[0] + column2[0];
            temp[1] = temp[1] + column2[1];
        }
        else if (op_type.compare("MINUS") == 0) {
            temp[0] = column2[0] - temp[0];
            temp[1] = column2[1] - temp[1];
        }
        else {
            temp[0] = column2[0] / temp[0];
            temp[1] = column2[1] / temp[1];
        }
    }
    else {
        if (op_type.compare("MUL") == 0) {
            temp[0] = temp[0] * column2[0];
            temp[1] = temp[1] * column2[1];
        }
        else if (op_type.compare("ADD") == 0) {
            temp[0] = temp[0] + column2[0];
            temp[1] = temp[1] + column2[1];
        }
        else if (op_type.compare("MINUS") == 0) {
            temp[0] = temp[0] - column2[0];
            temp[1] = temp[1] - column2[1];
        }
        else {
            temp[0] = temp[0] / column2[0];
            temp[1] = temp[1] / column2[1];
        }
    };

    return temp;
}




int_type* host_op(int_type* column1, int_type* column2, string op_type, int reverse)
{
    int_type* temp = (int_type*)malloc(2*int_size);

    if(reverse == 0) {
        if (op_type.compare("MUL") == 0) {
            temp[0] = column1[0] * column2[0];
            temp[1] = column1[1] * column2[1];
        }
        else if (op_type.compare("ADD") == 0) {
            temp[0] = column1[0] + column2[0];
            temp[1] = column1[1] + column2[1];
        }
        else if (op_type.compare("MINUS") == 0) {
            temp[0] = column1[0] - column2[0];
            temp[1] = column1[1] - column2[1];
        }
        else {
            temp[0] = column1[0] / column2[0];
            temp[1] = column1[1] / column2[1];
        }
    }
    else  {
        if (op_type.compare("MUL") == 0) {
            temp[0] = column1[0] * column2[0];
            temp[1] = column1[1] * column2[1];
        }
        else if (op_type.compare("ADD") == 0) {
            temp[0] = column1[0] + column2[0];
            temp[1] = column1[1] + column2[1];
        }
        else if (op_type.compare("MINUS") == 0) {
            temp[0] = column2[0] - column1[0];
            temp[1] = column2[1] - column1[1];
        }
        else {
            temp[0] = column2[0] / column1[0];
            temp[1] = column2[1] / column1[1];
        }
    }

    return temp;

}

float_type* host_op(float_type* column1, float_type* column2, string op_type, int reverse)
{
    float_type* temp = (float_type*)malloc(2*float_size);

    if(reverse == 0) {
        if (op_type.compare("MUL") == 0) {
            temp[0] = column1[0] * column2[0];
            temp[1] = column1[1] * column2[1];
        }
        else if (op_type.compare("ADD") == 0) {
            temp[0] = column1[0] + column2[0];
            temp[1] = column1[1] + column2[1];
        }
        else if (op_type.compare("MINUS") == 0) {
            temp[0] = column1[0] - column2[0];
            temp[1] = column1[1] - column2[1];
        }
        else {
            temp[0] = column1[0] / column2[0];
            temp[1] = column1[1] / column2[1];
        }
    }
    else  {
        if (op_type.compare("MUL") == 0) {
            temp[0] = column1[0] * column2[0];
            temp[1] = column1[1] * column2[1];
        }
        else if (op_type.compare("ADD") == 0) {
            temp[0] = column1[0] + column2[0];
            temp[1] = column1[1] + column2[1];
        }
        else if (op_type.compare("MINUS") == 0) {
            temp[0] = column2[0] - column1[0];
            temp[1] = column2[1] - column1[1];
        }
        else {
            temp[0] = column2[0] / column1[0];
            temp[1] = column2[1] / column1[1];
        }
    }

    return temp;

}

int_type* host_op(int_type* column1, int_type d, string op_type, int reverse)
{
    int_type* temp = (int_type*)malloc(2*int_size);

    if(reverse == 0) {
        if (op_type.compare("MUL") == 0) {
            temp[0] = column1[0] * d;
            temp[1] = column1[1] * d;
        }
        else if (op_type.compare("ADD") == 0) {
            temp[0] = column1[0] + d;
            temp[1] = column1[1] + d;
        }
        else if (op_type.compare("MINUS") == 0) {
            temp[0] = column1[0] - d;
            temp[1] = column1[1] - d;
        }
        else {
            temp[0] = column1[0] / d;
            temp[1] = column1[1] / d;
        }
    }
    else {
        if (op_type.compare("MUL") == 0) {
            temp[0] = column1[0] * d;
            temp[1] = column1[1] * d;
        }
        else if (op_type.compare("ADD") == 0) {
            temp[0] = column1[0] + d;
            temp[1] = column1[1] + d;
        }
        else if (op_type.compare("MINUS") == 0) {
            temp[0] = d - column1[0];
            temp[1] = d - column1[1];
        }
        else {
            temp[0] = d / column1[0];
            temp[1] = d / column1[1];
        }

    };
    return temp;

}

float_type* host_op(int_type* column1, float_type d, string op_type, int reverse)
{
    float_type* temp = (float_type*)malloc(2*float_size);
    temp[0] = (float_type)column1[0];
    temp[1] = (float_type)column1[1];

    float_type* temp1 = (float_type*)malloc(2*float_size);

    if(reverse == 0) {
        if (op_type.compare("MUL") == 0) {
            temp1[0] = temp[0] * d;
            temp1[1] = temp[1] * d;
        }
        else if (op_type.compare("ADD") == 0) {
            temp1[0] = temp[0] + d;
            temp1[1] = temp[1] + d;
        }
        else if (op_type.compare("MINUS") == 0) {
            temp1[0] = temp[0] - d;
            temp1[1] = temp[1] - d;
        }
        else {
            temp1[0] = temp[0] / d;
            temp1[1] = temp[1] / d;
        }
    }
    else  {
        if (op_type.compare("MUL") == 0) {
            temp1[0] = temp[0] * d;
            temp1[1] = temp[1] * d;
        }
        else if (op_type.compare("ADD") == 0) {
            temp1[0] = temp[0] + d;
            temp1[1] = temp[1] + d;
        }
        else if (op_type.compare("MINUS") == 0) {
            temp1[0] = d - temp[0];
            temp1[1] = d - temp[1];
        }
        else {
            temp1[0] = d / temp[0];
            temp1[1] = d / temp[1];
        }
    };

    free(temp);
    return temp1;

}



float_type* host_op(float_type* column1, float_type d, string op_type,int reverse)
{
    float_type* temp = (float_type*)malloc(2*float_size);

    if(reverse == 0) {
        if (op_type.compare("MUL") == 0) {
            temp[0] = column1[0] * d;
            temp[1] = column1[1] * d;
        }
        else if (op_type.compare("ADD") == 0) {
            temp[0] = column1[0] + d;
            temp[1] = column1[1] + d;
        }
        else if (op_type.compare("MINUS") == 0) {
            temp[0] = column1[0] - d;
            temp[1] = column1[1] - d;
        }
        else {
            temp[0] = column1[0] / d;
            temp[1] = column1[1] / d;
        }
    }
    else {
        if (op_type.compare("MUL") == 0) {
            temp[0] = column1[0] * d;
            temp[1] = column1[1] * d;
        }
        else if (op_type.compare("ADD") == 0) {
            temp[0] = column1[0] + d;
            temp[1] = column1[1] + d;
        }
        else if (op_type.compare("MINUS") == 0) {
            temp[0] = d - column1[0];
            temp[1] = d - column1[1];
        }
        else {
            temp[0] = d / column1[0];
            temp[1] = d / column1[1];
        }
    };

    return temp;

}


unsigned int precision_func(unsigned int& p1, unsigned int& p2, string op) {

	if (op.compare("DIV") != 0 ) {
		unsigned int res;
		if (op.compare("MUL") != 0 ) {			
			if(p1 > p2) {
				res = p1;				
				p2 = p1-p2;				
				p1 = 0;
			}	
			else {
				res = p1;				
				p1 = p2-p1;				
				p2 = 0; 
			};				
			return res;
		}	
		else {
			//std::swap(p1,p2);
			res = p1+p2;
			p1 = 0;
			p2 = 0;
			return res;
		};	
	}
	else {
		if(p1 == p2) {
			p1 = p1+4;			
			p2 = 0;
			return p1;				
		}
		else {
			if(p1 > p2) {
				p1 = p1 + (p1-p2) + 4;
				p2 = 0;
				return p1;
			}
			else {
				p2 = p2 + (p2-p1) + 4;
				p1 = 0;
				return p2;
			}						
		}		
	};
}



//CudaSet a contains two records - with all minimum and maximum values of the segment
//We need to determine if this segment needs to be processed
//The check takes place in host's memory

char zone_map_check(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums,queue<float_type> op_nums_f, queue<unsigned int> op_nums_precision, CudaSet* a, unsigned int segment)
{

    stack<string> exe_type;
    stack<string> exe_value;
    stack<int_type*> exe_vectors;
    stack<float_type*> exe_vectors_f;
    stack<int_type> exe_nums;
    stack<char> bool_vectors;
    stack<float_type> exe_nums_f;
	stack<unsigned int> exe_precision;
    string  s1, s2, s1_val, s2_val;
    int_type n1, n2, res;
    float_type n1_f, n2_f, res_f;

    if(a->not_compressed)
        return 'R';

    //first we need to set all host arrays [0] and [1] of t to min and max values of appropriate files
    set<string> uniques;
    queue<string> fields(op_value);
    CudaSet *t;
    FILE* f;
    unsigned int cnt;
    string f1;


    while(!fields.empty()) {
        if (uniques.count(fields.front()) == 0 && var_exists(a, fields.front()))	{

            if(a->filtered)
                t = varNames[a->source_name];
            else
                t = a;

            // copy t min and max values to a only if int, decimal or float
            if(t->type[fields.front()] <= 1) {

                f1 = t->load_file_name + "." + fields.front() + "." + to_string(segment);
                f = fopen (f1.c_str() , "rb" );
                if(!f) {
                	LOG(logERROR) << "Error opening " << f1 << " file ";
                    exit(0);
                };

                fread((char *)&cnt, 4, 1, f);
                if (t->type[fields.front()] == 0) {
                    a->h_columns_int[fields.front()].resize(2);
                    fread((char *)&a->h_columns_int[fields.front()][0], 8, 1, f);
                    fread((char *)&a->h_columns_int[fields.front()][1], 8, 1, f);
					fseek(f, 8+cnt, SEEK_CUR);
					fread((char *)&a->mRecCount, 4, 1, f);
					LOG(logDEBUG) << endl << "ZONE " << a->mRecCount;
					fread((char *)&cnt, 4, 1, f);					
					LOG(logDEBUG) << "file " << f1 << " " << segment << " " << a->h_columns_int[fields.front()][0] << ":" << a->h_columns_int[fields.front()][1];
                }
                else  {
                    long long int t;
                    a->h_columns_float[fields.front()].resize(2);
                    fread((char *)&t, 8, 1, f);
                    a->h_columns_float[fields.front()][0] = (float_type)t/100.0;
                    fread((char *)&t, 8, 1, f);
                    a->h_columns_float[fields.front()][1] = (float_type)t/100.0;
                    LOG(logDEBUG) << "file " << f1 << " " << segment << " " << a->h_columns_float[fields.front()][0] << ":" << a->h_columns_float[fields.front()][1];
                };
                fclose(f);
            };
        };
        uniques.insert(fields.front());
        fields.pop();
    };


    for(int i=0; !op_type.empty(); ++i, op_type.pop()) {

        string ss = op_type.front();
        LOG(logDEBUG) << ss;

        if (ss.compare("NAME") == 0 || ss.compare("NUMBER") == 0 || ss.compare("VECTOR") == 0 || ss.compare("FLOAT") == 0
                || ss.compare("STRING") == 0) {

            exe_type.push(ss);
            if (ss.compare("NUMBER") == 0) {
                exe_nums.push(op_nums.front());
                op_nums.pop();
				exe_precision.push(op_nums_precision.front());
				op_nums_precision.pop();
            }
            else if (ss.compare("NAME") == 0)  {
                if(var_exists(a, op_value.front())) {
                    exe_value.push(op_value.front());
                    op_value.pop();
                }
                else {
                    process_error(1, "Couldn't find column " + op_value.front());
                    LOG(logERROR) << "Couldn't find column " << op_value.front();
                    //exit(0);
                };
            }
            else if (ss.compare("STRING") == 0) {
                exe_value.push(op_value.front());
                op_value.pop();
            }
            if (ss.compare("FLOAT") == 0) {
                exe_nums_f.push(op_nums_f.front());
                op_nums_f.pop();
            }

        }
        else {
            if (ss.compare("MUL") == 0  || ss.compare("ADD") == 0 || ss.compare("DIV") == 0 || ss.compare("MINUS") == 0) {
                // get 2 values from the stack
                s1 = exe_type.top();
                exe_type.pop();
                s2 = exe_type.top();
                exe_type.pop();


                if (s1.compare("NUMBER") == 0 && s2.compare("NUMBER") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    n2 = exe_nums.top();
                    exe_nums.pop();
					auto p1 = exe_precision.top();
					exe_precision.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();					
					auto pres = precision_func(p1, p2, ss);	
					exe_precision.push(pres);
					
					if(p1) 
						n1 = n1*(unsigned int)pow(10,p1);
					if(p2) 
						n2 = n2*(unsigned int)pow(10,p2);

                    if (ss.compare("ADD") == 0 )
                        res = n1+n2;
                    else if (ss.compare("MUL") == 0 )
                        res = n1*n2;
                    else if (ss.compare("DIV") == 0 )
                        res = n1/n2;
                    else
                        res = n1-n2;


                    exe_type.push("NUMBER");
                    exe_nums.push(res);
                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("FLOAT") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    n2_f = exe_nums_f.top();
                    exe_nums_f.pop();

                    if (ss.compare("ADD") == 0 )
                        res_f = n1_f+n2_f;
                    else if (ss.compare("MUL") == 0 )
                        res_f = n1_f*n2_f;
                    else if (ss.compare("DIV") == 0 )
                        res_f = n1_f/n2_f;
                    else
                        res_f = n1_f-n2_f;

                    exe_type.push("FLOAT");
                    exe_nums_f.push(res_f);
                }
				else if (s1.compare("STRING") == 0 && s2.compare("STRING") == 0) { // date() + 3DAY or "1970-01-01 ..." + 2MONTH
				    s1_val = exe_value.top();
                    exe_value.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
					int_type val, tt;
					bool reverse = 1;

					auto pos = s2_val.find("date()");
					if(pos != string::npos) {
						tt = curr_time;		
					}
					else {
						pos = s2_val.find("-"); //"1970-
						if(pos != string::npos) {
							struct std::tm tm;														
							tm.tm_year = std::stoi(s2_val.substr(0,4))-1900;
							tm.tm_mon = std::stoi(s2_val.substr(5,2))-1;
							tm.tm_mday = std::stoi(s2_val.substr(8,2));
							tm.tm_hour = std::stoi(s2_val.substr(11,2));
							tm.tm_min = std::stoi(s2_val.substr(14,2));
							tm.tm_sec = std::stoi(s2_val.substr(17,2));								
							#ifdef _WIN64
							tt = _mkgmtime (&tm);
							#else
							tt = timegm (&tm);
							#endif								
							tt = tt*1000 + std::stoi(s2_val.substr(20,3));					
						}
						else {							
							reverse = 0;
							pos = s1_val.find("date()");
							if(pos != string::npos) {
								tt = curr_time;		
							}
							else {
								pos = s1_val.find("-"); //"1970-
								if(pos != string::npos) {
									struct std::tm tm;														
									tm.tm_year = std::stoi(s1_val.substr(0,4))-1900;
									tm.tm_mon = std::stoi(s1_val.substr(5,2))-1;
									tm.tm_mday = std::stoi(s1_val.substr(8,2));
									tm.tm_hour = std::stoi(s1_val.substr(11,2));
									tm.tm_min = std::stoi(s1_val.substr(14,2));
									tm.tm_sec = std::stoi(s1_val.substr(17,2));								
									#ifdef _WIN64
									tt = _mkgmtime (&tm);
									#else
									tt = timegm (&tm);
									#endif							
									tt = tt*1000 + std::stoi(s1_val.substr(20,3));					
								}
							};							
						};	
					};


					pos = s2_val.find("DAY");
					if(pos != string::npos) {
						val = stoi(s2_val.substr(0, pos)) * 24*60*60*1000;
					}					
					else {
						pos = s2_val.find("HOUR");
						if(pos != string::npos) {
							val = stoi(s2_val.substr(0, pos)) * 60*60*1000;
						}											
						else {
							pos = s2_val.find("MINUTE");
							if(pos != string::npos) {
								val = stoi(s2_val.substr(0, pos)) * 60*1000;								
							}											
							else {
								pos = s2_val.find("MSECOND");
								if(pos != string::npos) {
									val = stoi(s2_val.substr(0, pos));
								}											
								else {
									pos = s2_val.find("MONTH");
									if(pos != string::npos) {
										val = (add_interval(tt/1000, 0, stoi(s2_val.substr(0, pos)), 0, 0, 0, 0) - tt/1000)*1000;
									}						
									else {
										pos = s2_val.find("YEAR");
										if(pos != string::npos) {
											val = (add_interval(tt/1000, stoi(s2_val.substr(0, pos)), 0, 0, 0, 0, 0) - tt/1000)*1000;
										}							
										else {											
											pos = s1_val.find("DAY");
											if(pos != string::npos) {
												val = stoi(s1_val.substr(0, pos)) * 24*60*60*1000;
											}					
											else {
												pos = s1_val.find("HOUR");
												if(pos != string::npos) {
													val = stoi(s1_val.substr(0, pos)) * 60*60*1000;
												}											
												else {
													pos = s1_val.find("MINUTE");
													if(pos != string::npos) {
														val = stoi(s1_val.substr(0, pos)) * 60*1000;								
													}											
													else {
														pos = s1_val.find("MSECOND");
														if(pos != string::npos) {
															val = stoi(s1_val.substr(0, pos));
														}											
														else {
															pos = s1_val.find("MONTH");
															if(pos != string::npos) {
																val = stoi(s1_val.substr(0, pos));
																val = (add_interval(tt/1000, 0, val, 0, 0, 0, 0) - tt/1000)*1000;
															}						
															else {
																pos = s1_val.find("YEAR");
																if(pos != string::npos) {
																	val = stoi(s1_val.substr(0, pos));
																	val = (add_interval(tt/1000, val, 0, 0, 0, 0, 0) - tt/1000)*1000;
																}	
																else {
																	pos = s2_val.find("SECOND");
																	if(pos != string::npos) {
																		val = stoi(s2_val.substr(0, pos))*1000;
																	}	
																	else {
																		pos = s1_val.find("SECOND");
																		if(pos != string::npos) {
																			val = stoi(s1_val.substr(0, pos))*1000;
																		}	
																	}		
																}																		
															};								
														};
													};							
												};
											}											
										}	
									};									
								};
							};
						}	
					};				
	
					int_type res;
                    if (ss.compare("ADD") == 0 )
                        res = val+tt;
                    else {
						if(!reverse)
							res = val-tt;
						else
							res = tt- val;
					};	

                    exe_type.push("NUMBER");
                    exe_nums.push(res);		
					exe_precision.push(0);					
				}				
				
				else if (s1.compare("STRING") == 0 && s2.compare("NUMBER") == 0) {
				    s1_val = exe_value.top();
                    exe_value.pop();
					int_type val;
                    n1 = exe_nums.top();
                    exe_nums.pop();

					
					auto pos = s1_val.find("DAY");
					if(pos != string::npos) {
						val = stoi(s1_val.substr(0, pos)) * 24*60*60*1000;
					}					
					else {
						pos = s1_val.find("HOUR");
						if(pos != string::npos) {
							val = stoi(s1_val.substr(0, pos)) * 60*60*1000;
						}											
						else {
							pos = s1_val.find("MINUTE");
							if(pos != string::npos) {
								val = stoi(s1_val.substr(0, pos)) * 60*1000;								
							}											
							else {
								pos = s1_val.find("date()");
								if(pos != string::npos) {
									val = curr_time;								
								}																		
							}
						};
					};
					
					int_type res;
                    if (ss.compare("ADD") == 0 )
                        res = val+n1;
                    else
                        res = val-n1;

                    exe_type.push("NUMBER");
                    exe_nums.push(res);						
					exe_precision.push(0);					
				}
				
				else if (s2.compare("STRING") == 0 && s1.compare("NUMBER") == 0) {
				    s1_val = exe_value.top();
                    exe_value.pop();
					int_type val;
                    n1 = exe_nums.top();
                    exe_nums.pop();

					
					auto pos = s1_val.find("DAY");
					if(pos != string::npos) {
						val = stoi(s1_val.substr(0, pos)) * 24*60*60*1000;
					}					
					else {
						pos = s1_val.find("HOUR");
						if(pos != string::npos) {
							val = stoi(s1_val.substr(0, pos)) * 60*60*1000;
						}											
						else {
							pos = s1_val.find("MINUTE");
							if(pos != string::npos) {
								val = stoi(s1_val.substr(0, pos)) * 60*1000;								
							}											
							else {
								pos = s1_val.find("date()");
								if(pos != string::npos) {
									val = curr_time;								
								}																		
							}
						};
					};
					
					int_type res;
                    if (ss.compare("ADD") == 0 )
                        res = val+n1;
                    else
                        res = n1-val;

                    exe_type.push("NUMBER");
                    exe_nums.push(res);						
					exe_precision.push(0);					
				}
				
				
				else if (s1.compare("NAME") == 0 && s2.compare("STRING") == 0) {
                    s1_val = exe_value.top();
                    exe_value.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
					int_type val;
					int_type* t = a->get_host_int_by_name(s1_val);
					
					
					auto pos = s2_val.find("DAY");
					if(pos != string::npos) {
						val = stoi(s2_val.substr(0, pos));
						exe_vectors.push(host_op(t,val*24*60*60*1000,ss,1));
					}					
					else {
						pos = s2_val.find("HOUR");
						if(pos != string::npos) {
							val = stoi(s2_val.substr(0, pos));
							exe_vectors.push(host_op(t,val*60*60*1000,ss,1));						
						}											
						else {
							pos = s2_val.find("MINUTE");
							if(pos != string::npos) {
								val = stoi(s2_val.substr(0, pos));
								exe_vectors.push(host_op(t,val*60*1000,ss,1));						
							}											
							else {
								pos = s2_val.find("MSECOND");
								if(pos != string::npos) {
									val = stoi(s2_val.substr(0, pos));
									exe_vectors.push(host_op(t,val,ss,1));						
								}											
								else {
									pos = s2_val.find("MONTH");
									if(pos != string::npos) {
										val = stoi(s2_val.substr(0, pos));
									    int_type* temp = (int_type*)malloc(2*int_size);
										if (ss.compare("ADD") != 0 )
											val = -val;
										temp[0] = add_interval(t[0], 0, val, 0, 0, 0, 0);
										temp[1] = add_interval(t[1], 0, val, 0, 0, 0, 0);
										exe_vectors.push(temp);
									}						
									else {
										pos = s2_val.find("YEAR");
										if(pos != string::npos) {
											val = stoi(s2_val.substr(0, pos));
											int_type* temp = (int_type*)malloc(2*int_size);
											if (ss.compare("ADD") != 0 )
												val = -val;											
											temp[0] = add_interval(t[0], val, 0, 0, 0, 0, 0);
											temp[1] = add_interval(t[1], val, 0, 0, 0, 0, 0);
											exe_vectors.push(temp);
										}							
										else {
											pos = s2_val.find("SECOND");
											if(pos != string::npos) {
												val = stoi(s2_val.substr(0, pos));
												exe_vectors.push(host_op(t,val*1000,ss,1));						
											}	
										}	
									};									
								};
							};

						};
					}
					exe_type.push("VECTOR");
					exe_precision.push(0);
				}
				else if (s2.compare("NAME") == 0 && s1.compare("STRING") == 0) {
                    s1_val = exe_value.top();
                    exe_value.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
					int_type val;
					int_type* t = a->get_host_int_by_name(s2_val);
					LOG(logDEBUG) << "name " << s2_val;
					
					auto pos = s1_val.find("DAY");
					if(pos != string::npos) {
						val = stoi(s1_val.substr(0, pos));
						exe_vectors.push(host_op(t,val*24*60*60*1000,ss,0));
					}
					else {
						pos = s1_val.find("HOUR");
						if(pos != string::npos) {
							val = stoi(s1_val.substr(0, pos));
							exe_vectors.push(host_op(t,val*60*60*1000,ss,0));						
						}											
						else {
							pos = s1_val.find("MINUTE");
							if(pos != string::npos) {
								val = stoi(s1_val.substr(0, pos));
								exe_vectors.push(host_op(t,val*60*1000,ss,0));						
							}		
							else {
								pos = s1_val.find("MSECOND");
								if(pos != string::npos) {
									val = stoi(s1_val.substr(0, pos));
									exe_vectors.push(host_op(t,val,ss,1));						
								}											
								else {
									pos = s1_val.find("MONTH");
									if(pos != string::npos) {
										val = stoi(s1_val.substr(0, pos));
									    int_type* temp = (int_type*)malloc(2*int_size);
										if (ss.compare("ADD") != 0 )
											val = -val;
										temp[0] = add_interval(t[0], 0, val, 0, 0, 0, 0);
										temp[1] = add_interval(t[1], 0, val, 0, 0, 0, 0);
										exe_vectors.push(temp);
									}						
									else {
										pos = s1_val.find("YEAR");
										if(pos != string::npos) {
											val = stoi(s1_val.substr(0, pos));
											int_type* temp = (int_type*)malloc(2*int_size);
											if (ss.compare("ADD") != 0 )
												val = -val;											
											temp[0] = add_interval(t[0], val, 0, 0, 0, 0, 0);
											temp[1] = add_interval(t[1], val, 0, 0, 0, 0, 0);
											exe_vectors.push(temp);
										}		
										else {
											pos = s1_val.find("SECOND");
											if(pos != string::npos) {
												val = stoi(s1_val.substr(0, pos));
												exe_vectors.push(host_op(t,val*1000,ss,1));						
											}	
										}	
										
									};									
								};
							};
							
						};						
					}
					
					exe_type.push("VECTOR");
					exe_precision.push(0);
				}				
				
                else if (s1.compare("NAME") == 0 && s2.compare("FLOAT") == 0) {
                    s1_val = exe_value.top();
                    exe_value.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();

                    exe_type.push("VECTOR F");

                    if (a->type[s1_val] == 1) {
                        float_type* t = a->get_host_float_by_name(s1_val);
                        exe_vectors_f.push(host_op(t,n1_f,ss,1));
                    }
                    else {
                        int_type* t = a->get_host_int_by_name(s1_val);
                        exe_vectors_f.push(host_op(t,n1_f,ss,1));
                    };

                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("NAME") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();

                    exe_type.push("VECTOR F");

                    if (a->type[s2_val] == 1) {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        exe_vectors_f.push(host_op(t,n1_f,ss,0));
                    }
                    else {
                        int_type* t = a->get_host_int_by_name(s2_val);
                        exe_vectors_f.push(host_op(t,n1_f,ss,0));
                    };
                }
                else if (s1.compare("NAME") == 0 && s2.compare("NUMBER") == 0) {
                    s1_val = exe_value.top();
                    exe_value.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto p1 = a->decimal_zeroes[s1_val];					

                    if (a->type[s1_val] == 1) {
                        float_type* t = a->get_host_float_by_name(s1_val);
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(t,(float_type)n1,ss,1));
                    }
                    else {
                        int_type* t = a->get_host_int_by_name(s1_val);
						auto pres = precision_func(p1, p2, ss);	
						exe_precision.push(pres);
						if(p1) {
							t[0] = t[0]*(unsigned int)pow(10,p1);
							t[1] = t[1]*(unsigned int)pow(10,p1);
						};	
						if(p2) {
							n1 = n1*(unsigned int)pow(10,p2);
						};	
							
                        exe_type.push("VECTOR");
                        exe_vectors.push(host_op(t,n1,ss,1));
                    };
                }
                else if (s1.compare("NUMBER") == 0 && s2.compare("NAME") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto p1 = a->decimal_zeroes[s2_val];					

                    if (a->type[s2_val] == 1) {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(t,(float_type)n1,ss,0));
                    }
                    else {
                        int_type* t = a->get_host_int_by_name(s2_val);
						auto pres = precision_func(p1, p2, ss);	
						exe_precision.push(pres);
						if(p1) {
							t[0] = t[0]*(unsigned int)pow(10,p1);
							t[1] = t[1]*(unsigned int)pow(10,p1);
						};	
						if(p2) {
							n1 = n1*(unsigned int)pow(10,p2);
						};	

                        exe_type.push("VECTOR");
                        exe_vectors.push(host_op(t,n1,ss,0));
                    };
                }
                else if (s1.compare("NAME") == 0 && s2.compare("NAME") == 0) {

                    return 'R';
                }
                else if ((s1.compare("VECTOR") == 0 || s1.compare("VECTOR F") == 0 ) && s2.compare("NAME") == 0) {

                    s2_val = exe_value.top();
                    exe_value.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto p1 = a->decimal_zeroes[s2_val];					

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s2_val);

                        if (s1.compare("VECTOR") == 0 ) {
                            int_type* s3 = exe_vectors.top();
                            exe_vectors.pop();
                            exe_type.push("VECTOR");
							auto pres = precision_func(p1, p2,ss);	
							exe_precision.push(pres);
							
							if(p1) {
								t[0] = t[0]*(unsigned int)pow(10,p1);
								t[1] = t[1]*(unsigned int)pow(10,p1);
							};	
							if(p2) {
								s3[0] = s3[0]*(unsigned int)pow(10,p2);
								s3[1] = s3[1]*(unsigned int)pow(10,p2);
							};	
							
                            exe_vectors.push(host_op(t,s3,ss,0));
                            delete [] s3;
                        }
                        else {
                            float_type* s3 = exe_vectors_f.top();
                            exe_vectors_f.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(t,s3,ss,0));
                            delete [] s3;
                        }
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        if (s1.compare("VECTOR") == 0 ) {
                            int_type* s3 = exe_vectors.top();
                            exe_vectors.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(s3,t, ss,0));
                            delete [] s3;
                        }
                        else {
                            float_type* s3 = exe_vectors_f.top();
                            exe_vectors_f.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(t,s3,ss,0));
                            delete [] s3;
                        }
                    };
                }
                else if ((s2.compare("VECTOR") == 0 || s2.compare("VECTOR F") == 0 ) && s1.compare("NAME") == 0) {

                    s1_val = exe_value.top();
                    exe_value.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto p1 = a->decimal_zeroes[s1_val];					

                    if (a->type[s1_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s1_val);

                        if (s2.compare("VECTOR") == 0 ) {
                            int_type* s3 = exe_vectors.top();
                            exe_vectors.pop();
                            exe_type.push("VECTOR");
							auto pres = precision_func(p1, p2, ss);	
							exe_precision.push(pres);
							if(p1) {
								t[0] = t[0]*(unsigned int)pow(10,p1);
								t[1] = t[1]*(unsigned int)pow(10,p1);
							};	
							if(p2) {
								s3[0] = s3[0]*(unsigned int)pow(10,p2);
								s3[1] = s3[1]*(unsigned int)pow(10,p2);
							};	
							
                            exe_vectors.push(host_op(t,s3,ss,1));
                            delete [] s3;
                        }
                        else {
                            float_type* s3 = exe_vectors_f.top();
                            exe_vectors_f.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(t,s3,ss,1));
                            delete [] s3;
                        }
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s1_val);
                        if (s2.compare("VECTOR") == 0 ) {
                            int_type* s3 = exe_vectors.top();
                            exe_vectors.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(s3,t,ss,1));
                            delete [] s3;
                        }
                        else {
                            float_type* s3 = exe_vectors_f.top();
                            exe_vectors_f.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(t,s3,ss,1));
                            delete [] s3;
                        }
                    };
                }
                else if ((s1.compare("VECTOR") == 0 || s1.compare("VECTOR F") == 0)  && s2.compare("NUMBER") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();
					auto p1 = exe_precision.top();
					exe_precision.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();

                    if (s1.compare("VECTOR") == 0 ) {
                        int_type* s3 = exe_vectors.top();
                        exe_vectors.pop();
                        exe_type.push("VECTOR");
						auto pres = precision_func(p1, p2, ss);	
						exe_precision.push(pres);
						
						if(p1) {
							s3[0] = s3[0]*(unsigned int)pow(10,p1);
							s3[1] = s3[1]*(unsigned int)pow(10,p1);
						};	
						if(p2) {
							n1 = n1*(unsigned int)pow(10,p2);
						};	
						
                        exe_vectors.push(host_op(s3,n1, ss,1));
                        delete [] s3;
                    }
                    else {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(s3,(float_type)n1, ss,1));
                        delete [] s3;
                    }
                }
                else if (s1.compare("NUMBER") == 0 &&( s2.compare("VECTOR") || s2.compare("VECTOR F") == 0)) {
                    n1 = exe_nums.top();
                    exe_nums.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto p1 = exe_precision.top();
					exe_precision.pop();

                    if (s2.compare("VECTOR") == 0 ) {
                        int_type* s3 = exe_vectors.top();
                        exe_vectors.pop();
                        exe_type.push("VECTOR");
						auto pres = precision_func(p1, p2, ss);	
						exe_precision.push(pres);
						if(p1) {
							s3[0] = s3[0]*(unsigned int)pow(10,p1);
							s3[1] = s3[1]*(unsigned int)pow(10,p1);
						};	
						if(p2) {
							n1 = n1*(unsigned int)pow(10,p2);
						};	

                        exe_vectors.push(host_op(s3,n1, ss,0));
                        delete [] s3;
                    }
                    else {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(s3,(float_type)n1, ss,0));
                        delete [] s3;
                    }
                }

                else if ((s1.compare("VECTOR") == 0 || s1.compare("VECTOR F") == 0)  && s2.compare("FLOAT") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();

                    if (s1.compare("VECTOR") == 0 ) {
                        int_type* s3 = exe_vectors.top();
                        exe_vectors.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(s3,n1_f, ss,1));
                        delete [] s3;
                    }
                    else {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(s3,n1_f, ss,1));
                        delete [] s3;
                    }
                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("VECTOR") == 0) {
                    n1_f = (float_type)exe_nums.top();
                    exe_nums.pop();

                    if (s2.compare("VECTOR") == 0 ) {
                        int_type* s3 = exe_vectors.top();
                        exe_vectors.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(s3,n1_f, ss,0));
                        delete [] s3;
                    }
                    else {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(s3,n1_f, ss,0));
                        delete [] s3;
                    }
                }

				else if (s1.compare("VECTOR") == 0 && s2.compare("STRING") == 0) {
                    s2_val = exe_value.top();
                    exe_value.pop();
					int_type val;
                    int_type* s4 = exe_vectors.top();
					exe_vectors.pop();
					auto p1 = exe_precision.top();
					exe_precision.pop();
					
					auto pos = s2_val.find("DAY");
					if(pos != string::npos) {
						val = stoi(s2_val.substr(0, pos));
						exe_vectors.push(host_op(s4,val*24*60*60*1000,ss,1));
					}					
					else {
						pos = s2_val.find("HOUR");
						if(pos != string::npos) {
							val = stoi(s2_val.substr(0, pos));
							exe_vectors.push(host_op(s4,val*60*60*1000,ss,1));
						}
						else {
							pos = s2_val.find("MINUTE");
							if(pos != string::npos) {
								val = stoi(s2_val.substr(0, pos));
								exe_vectors.push(host_op(s4,val*60*1000,ss,1));
							}
							else {
								pos = s2_val.find("date()");
								if(pos != string::npos) {
									val = curr_time;							
									exe_vectors.push(host_op(s4,val,ss,1));									
								}
								else {
									pos = s2_val.find("MSECOND");
									if(pos != string::npos) {
										val = stoi(s2_val.substr(0, pos));
										exe_vectors.push(host_op(s4,val,ss,1));						
									}											
									else {
										pos = s2_val.find("MONTH");
										if(pos != string::npos) {
											val = stoi(s2_val.substr(0, pos));
											int_type* temp = (int_type*)malloc(2*int_size);
											if (ss.compare("ADD") != 0 )
												val = -val;
											temp[0] = add_interval(s4[0], 0, val, 0, 0, 0, 0);
											temp[1] = add_interval(s4[1], 0, val, 0, 0, 0, 0);
											exe_vectors.push(temp);
										}						
										else {
											pos = s2_val.find("YEAR");
											if(pos != string::npos) {
												val = stoi(s2_val.substr(0, pos));
												int_type* temp = (int_type*)malloc(2*int_size);
												if (ss.compare("ADD") != 0 )
													val = -val;											
												temp[0] = add_interval(s4[0], val, 0, 0, 0, 0, 0);
												temp[1] = add_interval(s4[1], val, 0, 0, 0, 0, 0);
												exe_vectors.push(temp);
											}							
											else {
												pos = s2_val.find("SECOND");
												if(pos != string::npos) {
													val = stoi(s2_val.substr(0, pos));
													exe_vectors.push(host_op(s4,val*1000,ss,1));						
												}											
											};
										}	
									};									
								};								
							}		
						};
					}
					exe_type.push("VECTOR");
					exe_precision.push(0);
				}
				
				else if (s2.compare("VECTOR") == 0 && s1.compare("STRING") == 0) {
                    s2_val = exe_value.top();
                    exe_value.pop();
					int_type val;
					int_type* s4 = exe_vectors.top();
					exe_vectors.pop();
					auto p1 = exe_precision.top();
					exe_precision.pop();
					
					auto pos = s2_val.find("DAY");
					if(pos != string::npos) {
						val = stoi(s2_val.substr(0, pos));
						exe_vectors.push(host_op(s4,val*24*60*60*1000,ss,0));
					}					
					else {
						pos = s2_val.find("HOUR");
						if(pos != string::npos) {
							val = stoi(s2_val.substr(0, pos));
							exe_vectors.push(host_op(s4,val*60*60*1000,ss,0));
						}
						else {
							pos = s2_val.find("MINUTE");
							if(pos != string::npos) {
								val = stoi(s2_val.substr(0, pos));
								exe_vectors.push(host_op(s4,val*60*1000,ss,0));
							}
							else {
								pos = s2_val.find("date()");
								if(pos != string::npos) {
									val = curr_time;							
									exe_vectors.push(host_op(s4,val,ss,0));									
								}	
								else {
									pos = s2_val.find("MSECOND");
									if(pos != string::npos) {
										val = stoi(s2_val.substr(0, pos));
										exe_vectors.push(host_op(s4,val,ss,1));						
									}											
									else {
										pos = s2_val.find("MONTH");
										if(pos != string::npos) {
											val = stoi(s2_val.substr(0, pos));
											int_type* temp = (int_type*)malloc(2*int_size);
											if (ss.compare("ADD") != 0 )
												val = -val;
											temp[0] = add_interval(s4[0], 0, val, 0, 0, 0, 0);
											temp[1] = add_interval(s4[1], 0, val, 0, 0, 0, 0);
											exe_vectors.push(temp);
										}						
										else {
											pos = s2_val.find("YEAR");
											if(pos != string::npos) {
												val = stoi(s2_val.substr(0, pos));
												int_type* temp = (int_type*)malloc(2*int_size);
												if (ss.compare("ADD") != 0 )
													val = -val;											
												temp[0] = add_interval(s4[0], val, 0, 0, 0, 0, 0);
												temp[1] = add_interval(s4[1], val, 0, 0, 0, 0, 0);
												exe_vectors.push(temp);
											}							
											else {
												pos = s2_val.find("SECOND");
												if(pos != string::npos) {
													val = stoi(s2_val.substr(0, pos));
													exe_vectors.push(host_op(s4,val*1000,ss,1));						
												}											
											}
										};									
									};
								};

							}
						};
					}

					
					exe_type.push("VECTOR");
					exe_precision.push(0);
				}
				
				
                else if (s1.compare("VECTOR") == 0 && s2.compare("VECTOR") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    int_type* s4 = exe_vectors.top();
                    exe_vectors.pop();
					auto p1 = exe_precision.top();
					exe_precision.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto pres = precision_func(p1, p2, ss);	
					exe_precision.push(pres);
					
					if(p1) {
						s3[0] = s3[0]*(unsigned int)pow(10,p1);
						s3[1] = s3[1]*(unsigned int)pow(10,p1);
					};	
					if(p2) {
						s4[0] = s4[0]*(unsigned int)pow(10,p2);
						s4[1] = s4[1]*(unsigned int)pow(10,p2);
					};						
					
					exe_type.push("VECTOR");
                    exe_vectors.push(host_op(s3, s4,ss,1));
                    delete [] s3;
                    delete [] s4;
                }
                else if(s1.compare("VECTOR") == 0 && s2.compare("VECTOR F") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    float_type* s4 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    exe_type.push("VECTOR F");
                    exe_vectors_f.push(host_op(s3, s4,ss,1));
                    delete [] s3;
                    delete [] s4;
                }
                else if(s1.compare("VECTOR F") == 0 && s2.compare("VECTOR") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    float_type* s4 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    exe_type.push("VECTOR F");
                    exe_vectors_f.push(host_op(s3, s4,ss,0));
                    delete [] s3;
                    delete [] s4;
                }
                else if(s1.compare("VECTOR F") == 0 && s2.compare("VECTOR F") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    float_type* s4 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    exe_type.push("VECTOR F");
                    exe_vectors_f.push(host_op(s3, s4,ss,1));
                    delete [] s3;
                    delete [] s4;
                }
            }

            else if (ss.compare("CMP") == 0) {

                int_type cmp_type = op_nums.front();
                op_nums.pop();

                s1 = exe_type.top();
                exe_type.pop();
                s2 = exe_type.top();
                exe_type.pop();


                if (s1.compare("NUMBER") == 0 && s2.compare("NUMBER") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    n2 = exe_nums.top();
                    exe_nums.pop();
					auto p1 = exe_precision.top();
					exe_precision.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();					
					auto pres = std::max(p1, p2);	
					exe_precision.push(pres);					
                    exe_type.push("VECTOR");
					if(p1) 
						n1 = n1*(unsigned int)pow(10,pres-p1);
					if(p2) 
						n2 = n2*(unsigned int)pow(10,pres-p2);
                    bool_vectors.push(host_compare(n1,n2,cmp_type));
                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("FLOAT") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    n2_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(n1_f,n2_f,cmp_type));
                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("NUMBER") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    n2 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(n1_f,float_type(n2),cmp_type));
                }
                else if (s1.compare("NUMBER") == 0 && s2.compare("FLOAT") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    n2 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(n1_f,float_type(n2),cmp_type));
                }

                else if (s1.compare("STRING") == 0 && s2.compare("NAME") == 0) {
                    //exe_type.push("VECTOR");
                    //bool_vectors.push('R'); // later I plan to change implementation of char type so I will leave indexing of char off for now
					//only date() can be in STRING					
					time_t tt;
                    s1_val = exe_value.top();
                    exe_value.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
					int_type val;
					int_type* t = a->get_host_int_by_name(s2_val);
					
					auto pos = s1_val.find("date()");
					if(pos != string::npos) {
						val = curr_time;
						bool_vectors.push(host_compare(t,val, cmp_type));
					}	
					else {
						pos = s1_val.find("-"); //"1970-
						if(pos != string::npos) {
							struct std::tm tm;														
							tm.tm_year = std::stoi(s1_val.substr(0,4))-1900;
							tm.tm_mon = std::stoi(s1_val.substr(5,2))-1;
							tm.tm_mday = std::stoi(s1_val.substr(8,2));
							tm.tm_hour = std::stoi(s1_val.substr(11,2));
							tm.tm_min = std::stoi(s1_val.substr(14,2));
							tm.tm_sec = std::stoi(s1_val.substr(17,2));								
							#ifdef _WIN64
							tt = _mkgmtime (&tm);
							#else
							tt = timegm (&tm);
							#endif								
							tt = tt*1000 + std::stoi(s1_val.substr(20,3));					
							bool_vectors.push(host_compare(t,tt, cmp_type));
						}
						else
							bool_vectors.push('R');
					};


					
					exe_type.push("VECTOR");
                }
                else if (s1.compare("NAME") == 0 && s2.compare("STRING") == 0) {
                    //exe_type.push("VECTOR");
                    //bool_vectors.push('R');
                    s2_val = exe_value.top();
                    exe_value.pop();
                    s1_val = exe_value.top();
                    exe_value.pop();
					int_type val;
					time_t tt;
					int_type* t = a->get_host_int_by_name(s1_val);
					
					auto pos = s2_val.find("date()");
					if(pos != string::npos) {
						val = curr_time;
						bool_vectors.push(host_compare(t,val, cmp_type));
					}	
					else {
						pos = s2_val.find("-"); //"1970-
						if(pos != string::npos) {
							struct std::tm tm;														
							tm.tm_year = std::stoi(s2_val.substr(0,4))-1900;
							tm.tm_mon = std::stoi(s2_val.substr(5,2))-1;
							tm.tm_mday = std::stoi(s2_val.substr(8,2));
							tm.tm_hour = std::stoi(s2_val.substr(11,2));
							tm.tm_min = std::stoi(s2_val.substr(14,2));
							tm.tm_sec = std::stoi(s2_val.substr(17,2));								
							#ifdef _WIN64
							tt = _mkgmtime (&tm);
							#else
							tt = timegm (&tm);
							#endif								
							tt = tt*1000 + std::stoi(s2_val.substr(20,3));					
							bool_vectors.push(host_compare(t,tt, cmp_type));
						}
						else
							bool_vectors.push('R');
					};
					exe_type.push("VECTOR");
                }


                else if (s1.compare("NUMBER") == 0 && s2.compare("NAME") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    s1_val = exe_value.top();
                    exe_value.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto p1 = a->decimal_zeroes[s2_val];					

                    if (a->type[s1_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s1_val);
                        exe_type.push("VECTOR");
						auto pres = std::max(p1, p2);	
						exe_precision.push(pres);
						
						if(p1) {
							t[0] = t[0]*(unsigned int)pow(10,pres-p1);
							t[1] = t[1]*(unsigned int)pow(10,pres-p1);
						};	
						if(p2) {
							n1 = n1*(unsigned int)pow(10,pres-p2);
						};							
						
                        bool_vectors.push(host_compare(t,n1,cmp_type));
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s1_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(host_compare(t,(float_type)n1,cmp_type));
                    };
                }
                else if (s1.compare("NAME") == 0 && s2.compare("NUMBER") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto p1 = a->decimal_zeroes[s2_val];					

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s2_val);
                        exe_type.push("VECTOR");
						auto pres = std::max(p1, p2);	
						exe_precision.push(pres);
						if(p1) {
							t[0] = t[0]*(unsigned int)pow(10,pres-p1);
							t[1] = t[1]*(unsigned int)pow(10,pres-p1);
						};	
						if(p2) {
							n1 = n1*(unsigned int)pow(10,pres-p2);
						};							

                        bool_vectors.push(host_compare(t,n1,cmp_type));
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(host_compare(t,(float_type)n1,cmp_type));
                    };
                }

                else if (s1.compare("FLOAT") == 0 && s2.compare("NAME") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    s1_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s1_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s1_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(host_compare(t,n1_f,cmp_type));
                    }
                    else {

                        float_type* t = a->get_host_float_by_name(s1_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(host_compare(t,n1_f,cmp_type));
                    };
                }
                else if (s1.compare("NAME") == 0 && s2.compare("FLOAT") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s2_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(host_compare(t,(int_type)n1_f,cmp_type));
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(host_compare(t,n1_f,cmp_type));
                    };
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("NUMBER") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,(float_type)n1,cmp_type));
                    delete [] s3;
                }

                else if (s1.compare("VECTOR") == 0 && s2.compare("NUMBER") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();
					auto p1 = exe_precision.top();
					exe_precision.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto pres = std::max(p1, p2);	
					exe_precision.push(pres);
					
					if(p1) {
						s3[0] = s3[0]*(unsigned int)pow(10,pres-p1);
						s3[1] = s3[1]*(unsigned int)pow(10,pres-p1);
					};	
					if(p2) {
						n1 = n1*(unsigned int)pow(10,pres-p2);
					};							
					
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,n1,cmp_type));
                    delete [] s3;
                }
                else if (s1.compare("NUMBER") == 0 && s2.compare("VECTOR F") == 0) {

                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,(float_type)n1,cmp_type));
                    delete [] s3;
                }

                else if (s1.compare("NUMBER") == 0 && s2.compare("VECTOR") == 0) {

                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto p1 = exe_precision.top();
					exe_precision.pop();
					auto pres = std::max(p1, p2);	
					exe_precision.push(pres);
					if(p1) {
						s3[0] = s3[0]*(unsigned int)pow(10,pres-p1);
						s3[1] = s3[1]*(unsigned int)pow(10,pres-p1);
					};	
					if(p2) {
						n1 = n1*(unsigned int)pow(10,pres-p2);
					};							
					
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,n1,cmp_type));
                    delete [] s3;
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("FLOAT") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,n1_f,cmp_type));
                    delete [] s3;
                }
                else if (s1.compare("VECTOR") == 0 && s2.compare("FLOAT") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,(int_type)n1_f,cmp_type));
                    delete [] s3;
                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("VECTOR F") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,n1_f,cmp_type));
                    delete [] s3;
                }

                else if (s1.compare("FLOAT") == 0 && s2.compare("VECTOR") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,(int_type)n1_f,cmp_type));
                    delete [] s3;
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("NAME") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s2_val);
                        bool_vectors.push(host_compare(s3,t,cmp_type));
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        bool_vectors.push(host_compare(t,s3,cmp_type));
                    };
                    delete [] s3;
                }
				
				else if (s1.compare("VECTOR") == 0 && s2.compare("STRING") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");
					exe_precision.pop();
					time_t tt;
					
					auto pos = s2_val.find("date()");
					if(pos != string::npos) {
						tt = curr_time;								
					}
					else {
						pos = s2_val.find("-"); //"1970-
						if(pos != string::npos) {
							struct std::tm tm;														
							tm.tm_year = std::stoi(s2_val.substr(0,4))-1900;
							tm.tm_mon = std::stoi(s2_val.substr(5,2))-1;
							tm.tm_mday = std::stoi(s2_val.substr(8,2));
							tm.tm_hour = std::stoi(s2_val.substr(11,2));
							tm.tm_min = std::stoi(s2_val.substr(14,2));
							tm.tm_sec = std::stoi(s2_val.substr(17,2));								
							#ifdef _WIN64
							tt = _mkgmtime (&tm);
							#else
							tt = timegm (&tm);
							#endif								
							tt = tt*1000 + std::stoi(s2_val.substr(20,3));					
						}
					};
					
					
					
                    bool_vectors.push(host_compare(s3,tt,cmp_type));
                    delete [] s3;
				}
				
				else if (s2.compare("VECTOR") == 0 && s1.compare("STRING") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");
					exe_precision.pop();					
					time_t tt;
					
					auto pos = s2_val.find("date()");
					if(pos != string::npos) {
						tt = curr_time;								
					}
					else {
						pos = s2_val.find("-"); //"1970-
						if(pos != string::npos) {
							struct std::tm tm;														
							tm.tm_year = std::stoi(s2_val.substr(0,4))-1900;
							tm.tm_mon = std::stoi(s2_val.substr(5,2))-1;
							tm.tm_mday = std::stoi(s2_val.substr(8,2));
							tm.tm_hour = std::stoi(s2_val.substr(11,2));
							tm.tm_min = std::stoi(s2_val.substr(14,2));
							tm.tm_sec = std::stoi(s2_val.substr(17,2));								
							#ifdef _WIN64
							tt = _mkgmtime (&tm);
							#else
							tt = timegm (&tm);
							#endif								
							tt = tt*1000 + std::stoi(s2_val.substr(20,3));					
						}
					};

                    bool_vectors.push(host_compare(s3,tt,cmp_type));
                    delete [] s3;
				}


                else if (s1.compare("VECTOR") == 0 && s2.compare("NAME") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto p1 = a->decimal_zeroes[s2_val];					


                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s2_val);
						auto pres = std::max(p1, p2);	
						exe_precision.push(pres);
						if(p1) {
							t[0] = t[0]*(unsigned int)pow(10,pres-p1);
							t[1] = t[1]*(unsigned int)pow(10,pres-p1);
						};	
						if(p2) {
							s3[0] = s3[0]*(unsigned int)pow(10,pres-p2);
							s3[1] = s3[1]*(unsigned int)pow(10,pres-p2);
						};							

                        bool_vectors.push(host_compare(t,s3,cmp_type));
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        bool_vectors.push(host_compare(t,s3,cmp_type));
                    };
                    delete [] s3;
                }

                else if (s1.compare("NAME") == 0 && s2.compare("VECTOR F") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s2_val);
                        bool_vectors.push(host_compare(s3,t,cmp_type));
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        bool_vectors.push(host_compare(t,s3,cmp_type));
                    };
                    delete [] s3;
                }

                else if (s1.compare("NAME") == 0 && s2.compare("VECTOR") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto p1 = a->decimal_zeroes[s2_val];					

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s2_val);
						auto pres = std::max(p1, p2);	
						exe_precision.push(pres);
						if(p1) {
							t[0] = t[0]*(unsigned int)pow(10,pres-p1);
							t[1] = t[1]*(unsigned int)pow(10,pres-p1);
						};	
						if(p2) {
							s3[0] = s3[0]*(unsigned int)pow(10,pres-p2);
							s3[1] = s3[1]*(unsigned int)pow(10,pres-p2);
						};							

                        bool_vectors.push(host_compare(t,s3,cmp_type));
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        bool_vectors.push(host_compare(t,s3,cmp_type));
                    };
                    delete [] s3;
                }

                else if (s1.compare("VECTOR") == 0 && s2.compare("VECTOR") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    int_type* s2 = exe_vectors.top();
                    exe_vectors.pop();
                    exe_type.push("VECTOR");
					auto p1 = exe_precision.top();
					exe_precision.pop();
					auto p2 = exe_precision.top();
					exe_precision.pop();
					auto pres = std::max(p2, p1);	
					exe_precision.push(pres);
					if(p1) {
						s3[0] = s3[0]*(unsigned int)pow(10,pres-p1);
						s3[1] = s3[1]*(unsigned int)pow(10,pres-p1);
					};	
					if(p2) {
						s2[0] = s2[0]*(unsigned int)pow(10,pres-p2);
						s2[1] = s2[1]*(unsigned int)pow(10,pres-p2);
					};							
					
                    bool_vectors.push(host_compare(s2,s3,cmp_type));
                    delete [] s3;
                    delete [] s2;
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("VECTOR F") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    float_type* s2 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s2,s3,cmp_type));
                    delete [] s3;
                    delete [] s2;
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("VECTOR") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    int_type* s2 = exe_vectors.top();
                    exe_vectors.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,s2,cmp_type));
                    delete [] s3;
                    delete [] s2;
                }

                else if (s1.compare("VECTOR") == 0 && s2.compare("VECTOR F") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    int_type* s2 = exe_vectors.top();
                    exe_vectors.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,s2,cmp_type));
                    delete [] s3;
                    delete [] s2;
                }


                else if (s1.compare("NAME") == 0 && s2.compare("NAME") == 0) {
                    return 'R';
                }
            }

            else if (ss.compare("AND") == 0) {
                char s3 = bool_vectors.top();
                bool_vectors.pop();
                char s2 = bool_vectors.top();
                bool_vectors.pop();
                exe_type.push("VECTOR");
                bool_vectors.push(host_logical_and(s2,s3));
            }
            else if (ss.compare("OR") == 0) {
                char s3 = bool_vectors.top();
                bool_vectors.pop();
                char s2 = bool_vectors.top();
                bool_vectors.pop();
                exe_type.push("VECTOR");
                bool_vectors.push(host_logical_or(s2,s3));
            }
            else {
                if(ss.compare("JOIN") == 0){
                	LOG(logERROR) << "operation = is not valid";
                    process_error(2, "operation = is not valid");
                }
                else {
                	LOG(logERROR) << "operation = is not valid";
                    process_error(2, "operation " + string(ss)+ " is not valid");
					exit(0);	// never gets here
                }
            }
        };
    };


    return bool_vectors.top();

}

