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
    //cout << "AND " << column1 << " " << column2 << endl;
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
    //cout << "OR " << column1 << " " << column2 << endl;
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
    //cout << "CMP " << column1[0] << " " << column1[1] << " with " << d << endl;

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
    //cout << "res " << res << endl;

    return res;
}

char host_compare(float_type* column1, float_type d, int_type op_type)
{
    char res = 'R';
    //cout << "CMP " << column1[0] << " " << column1[1] << " with " << d << endl;

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

    //cout << "res " << res << endl;
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



//CudaSet a contains two records - with all minimum and maximum values of the segment
//We need to determine if this segment needs to be processed
//The check takes place in host's memory

char zone_map_check(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums,queue<float_type> op_nums_f, CudaSet* a, unsigned int segment)
{

    stack<string> exe_type;
    stack<string> exe_value;
    stack<int_type*> exe_vectors;
    stack<float_type*> exe_vectors_f;
    stack<int_type> exe_nums;
    stack<char> bool_vectors;
    stack<float_type> exe_nums_f;
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
                    cout << "Error opening " << f1 << " file " << endl;
                    exit(0);
                };

                fread((char *)&cnt, 4, 1, f);
                if (t->type[fields.front()] == 0) {
                    a->h_columns_int[fields.front()].resize(2);
                    fread((char *)&a->h_columns_int[fields.front()][0], 8, 1, f);
                    fread((char *)&a->h_columns_int[fields.front()][1], 8, 1, f);
                    //cout << "file " << f1 << " " << segment << " " << a->h_columns_int[fields.front()][0] << ":" << a->h_columns_int[fields.front()][1] << endl;
                }
                else  {
                    long long int t;
                    a->h_columns_float[fields.front()].resize(2);
                    fread((char *)&t, 8, 1, f);
                    a->h_columns_float[fields.front()][0] = (float_type)t/100.0;
                    fread((char *)&t, 8, 1, f);
                    a->h_columns_float[fields.front()][1] = (float_type)t/100.0;
                    //cout << "file " << f1 << " " << segment << " " << a->h_columns_float[a->type_index[colIndex]][0] << ":" << a->h_columns_float[a->type_index[colIndex]][1] << endl;
                };
                fclose(f);
            };
        };
        uniques.insert(fields.front());
        fields.pop();
    };


    for(int i=0; !op_type.empty(); ++i, op_type.pop()) {

        string ss = op_type.front();

        if (ss.compare("NAME") == 0 || ss.compare("NUMBER") == 0 || ss.compare("VECTOR") == 0 || ss.compare("FLOAT") == 0
                || ss.compare("STRING") == 0) {

            exe_type.push(ss);
            if (ss.compare("NUMBER") == 0) {
                exe_nums.push(op_nums.front());
                op_nums.pop();
            }
            else if (ss.compare("NAME") == 0)  {
                if(var_exists(a, op_value.front())) {
                    exe_value.push(op_value.front());
                    op_value.pop();
                }
                else {
                    process_error(1, "Couldn't find column " + op_value.front());
                    //cout << "Couldn't find column " << op_value.front() << endl;
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

                    if (a->type[s1_val] == 1) {
                        float_type* t = a->get_host_float_by_name(s1_val);
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(t,(float_type)n1,ss,1));

                    }
                    else {
                        int_type* t = a->get_host_int_by_name(s1_val);
                        exe_type.push("VECTOR");
                        exe_vectors.push(host_op(t,n1,ss,1));
                    };
                }
                else if (s1.compare("NUMBER") == 0 && s2.compare("NAME") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();


                    if (a->type[s2_val] == 1) {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(t,(float_type)n1,ss,0));
                    }
                    else {
                        int_type* t = a->get_host_int_by_name(s2_val);
                        exe_type.push("VECTOR");
                        exe_vectors.push(host_op(t,n1,ss,0));
                    };
                }
                else if (s1.compare("NAME") == 0 && s2.compare("NAME") == 0) {

                    return 'R';
                    /*s1_val = exe_value.top();
                    exe_value.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s1_val] == 0) {
                        int_type* t1 = a->get_host_int_by_name(s1_val);
                        if (a->type[s2_val] == 0) {
                            int_type* t = a->get_host_int_by_name(s2_val);
                            exe_type.push("VECTOR");
                            exe_vectors.push(host_op(t,t1,ss,0));
                        }
                        else {
                            float_type* t = a->get_host_float_by_name(s2_val);
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(t1,t,ss,0));
                        };
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s1_val);
                        if (a->type[s2_val] == 0) {
                            int_type* t1 = a->get_host_int_by_name(s2_val);
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(t1,t,ss,0));
                        }
                        else {
                            float_type* t1 = a->get_host_float_by_name(s2_val);
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(t,t1,ss,0));
                        };
                    }
                    */
                }
                else if ((s1.compare("VECTOR") == 0 || s1.compare("VECTOR F") == 0 ) && s2.compare("NAME") == 0) {

                    s2_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s2_val);

                        if (s1.compare("VECTOR") == 0 ) {
                            int_type* s3 = exe_vectors.top();
                            exe_vectors.pop();
                            exe_type.push("VECTOR");
                            exe_vectors.push(host_op(t,s3,ss,0));
                            //free s3
                            cudaFree(s3);

                        }
                        else {
                            float_type* s3 = exe_vectors_f.top();
                            exe_vectors_f.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(t,s3,ss,0));
                            cudaFree(s3);
                        }
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        if (s1.compare("VECTOR") == 0 ) {
                            int_type* s3 = exe_vectors.top();
                            exe_vectors.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(s3,t, ss,0));
                            cudaFree(s3);
                        }
                        else {
                            float_type* s3 = exe_vectors_f.top();
                            exe_vectors_f.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(t,s3,ss,0));
                            cudaFree(s3);
                        }
                    };
                }
                else if ((s2.compare("VECTOR") == 0 || s2.compare("VECTOR F") == 0 ) && s1.compare("NAME") == 0) {

                    s1_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s1_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s1_val);

                        if (s2.compare("VECTOR") == 0 ) {
                            int_type* s3 = exe_vectors.top();
                            exe_vectors.pop();
                            exe_type.push("VECTOR");
                            exe_vectors.push(host_op(t,s3,ss,1));
                            cudaFree(s3);
                        }
                        else {
                            float_type* s3 = exe_vectors_f.top();
                            exe_vectors_f.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(t,s3,ss,1));
                            cudaFree(s3);
                        }
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s1_val);
                        if (s2.compare("VECTOR") == 0 ) {
                            int_type* s3 = exe_vectors.top();
                            exe_vectors.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(s3,t,ss,1));
                            cudaFree(s3);
                        }
                        else {
                            float_type* s3 = exe_vectors_f.top();
                            exe_vectors_f.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(host_op(t,s3,ss,1));
                            cudaFree(s3);
                        }
                    };
                }
                else if ((s1.compare("VECTOR") == 0 || s1.compare("VECTOR F") == 0)  && s2.compare("NUMBER") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();

                    if (s1.compare("VECTOR") == 0 ) {
                        int_type* s3 = exe_vectors.top();
                        exe_vectors.pop();
                        exe_type.push("VECTOR");
                        exe_vectors.push(host_op(s3,n1, ss,1));
                        cudaFree(s3);
                    }
                    else {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(s3,(float_type)n1, ss,1));
                        cudaFree(s3);
                    }
                }
                else if (s1.compare("NUMBER") == 0 && s2.compare("VECTOR") || s2.compare("VECTOR F") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();

                    if (s2.compare("VECTOR") == 0 ) {
                        int_type* s3 = exe_vectors.top();
                        exe_vectors.pop();
                        exe_type.push("VECTOR");
                        exe_vectors.push(host_op(s3,n1, ss,0));
                        cudaFree(s3);
                    }
                    else {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(s3,(float_type)n1, ss,0));
                        cudaFree(s3);
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
                        cudaFree(s3);
                    }
                    else {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(s3,n1_f, ss,1));
                        cudaFree(s3);
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
                        cudaFree(s3);
                    }
                    else {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(host_op(s3,n1_f, ss,0));
                        cudaFree(s3);
                    }
                }

                else if (s1.compare("VECTOR") == 0 && s2.compare("VECTOR") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    int_type* s4 = exe_vectors.top();
                    exe_vectors.pop();
                    exe_type.push("VECTOR");
                    exe_vectors.push(host_op(s3, s4,ss,1));
                    cudaFree(s3);
                    cudaFree(s4);
                }
                else if(s1.compare("VECTOR") == 0 && s2.compare("VECTOR F") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    float_type* s4 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    exe_type.push("VECTOR F");
                    exe_vectors_f.push(host_op(s3, s4,ss,1));
                    cudaFree(s3);
                    cudaFree(s4);
                }
                else if(s1.compare("VECTOR F") == 0 && s2.compare("VECTOR") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    float_type* s4 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    exe_type.push("VECTOR F");
                    exe_vectors_f.push(host_op(s3, s4,ss,0));
                    cudaFree(s3);
                    cudaFree(s4);
                }
                else if(s1.compare("VECTOR F") == 0 && s2.compare("VECTOR F") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    float_type* s4 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    exe_type.push("VECTOR F");
                    exe_vectors_f.push(host_op(s3, s4,ss,1));
                    cudaFree(s3);
                    cudaFree(s4);
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
                    exe_type.push("VECTOR");
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
                    exe_type.push("VECTOR");
                    bool_vectors.push('R'); // later I plan to change implementation of char type so I will leave indexing of char off for now
                }
                else if (s1.compare("NAME") == 0 && s2.compare("STRING") == 0) {
                    exe_type.push("VECTOR");
                    bool_vectors.push('R');
                }


                else if (s1.compare("NUMBER") == 0 && s2.compare("NAME") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    s1_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s1_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s1_val);
                        exe_type.push("VECTOR");
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

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s2_val);
                        exe_type.push("VECTOR");
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
                    cudaFree(s3);
                }

                else if (s1.compare("VECTOR") == 0 && s2.compare("NUMBER") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,n1,cmp_type));
                    cudaFree(s3);
                }
                else if (s1.compare("NUMBER") == 0 && s2.compare("VECTOR F") == 0) {

                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,(float_type)n1,cmp_type));
                    cudaFree(s3);
                }

                else if (s1.compare("NUMBER") == 0 && s2.compare("VECTOR") == 0) {

                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,n1,cmp_type));
                    cudaFree(s3);
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("FLOAT") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,n1_f,cmp_type));
                    cudaFree(s3);
                }
                else if (s1.compare("VECTOR") == 0 && s2.compare("FLOAT") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,(int_type)n1_f,cmp_type));
                    cudaFree(s3);
                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("VECTOR F") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,n1_f,cmp_type));
                    cudaFree(s3);
                }

                else if (s1.compare("FLOAT") == 0 && s2.compare("VECTOR") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,(int_type)n1_f,cmp_type));
                    cudaFree(s3);
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
                    cudaFree(s3);
                }


                else if (s1.compare("VECTOR") == 0 && s2.compare("NAME") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s2_val);
                        bool_vectors.push(host_compare(t,s3,cmp_type));
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        bool_vectors.push(host_compare(t,s3,cmp_type));
                    };
                    cudaFree(s3);
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
                    cudaFree(s3);
                }

                else if (s1.compare("NAME") == 0 && s2.compare("VECTOR") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s2_val);
                        bool_vectors.push(host_compare(t,s3,cmp_type));
                    }
                    else {
                        float_type* t = a->get_host_float_by_name(s2_val);
                        bool_vectors.push(host_compare(t,s3,cmp_type));
                    };
                    cudaFree(s3);
                }

                else if (s1.compare("VECTOR") == 0 && s2.compare("VECTOR") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    int_type* s2 = exe_vectors.top();
                    exe_vectors.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s2,s3,cmp_type));
                    cudaFree(s3);
                    cudaFree(s2);
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("VECTOR F") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    float_type* s2 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s2,s3,cmp_type));
                    cudaFree(s3);
                    cudaFree(s2);
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("VECTOR") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    int_type* s2 = exe_vectors.top();
                    exe_vectors.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,s2,cmp_type));
                    cudaFree(s3);
                    cudaFree(s2);
                }

                else if (s1.compare("VECTOR") == 0 && s2.compare("VECTOR F") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    int_type* s2 = exe_vectors.top();
                    exe_vectors.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(host_compare(s3,s2,cmp_type));
                    cudaFree(s3);
                    cudaFree(s2);
                }


                else if (s1.compare("NAME") == 0 && s2.compare("NAME") == 0) {
                    return 'R';
                    /*
                    s1_val = exe_value.top();
                    exe_value.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");

                    if (a->type[s1_val] == 0) {
                        int_type* t = a->get_host_int_by_name(s1_val);
                        if (a->type[s2_val] == 0) {
                            int_type* t1 = a->get_host_int_by_name(s2_val);
                            bool_vectors.push(host_compare(t1,t,cmp_type));
                        }
                        else {
                            float_type* t1 = a->get_host_float_by_name(s2_val);
                            bool_vectors.push(host_compare(t1,t,cmp_type));
                        };
                    }
                    else {
                        cmp_type = reverse_op(cmp_type);
                        float_type* t = a->get_host_float_by_name(s1_val);
                        if (a->type[s2_val] == 0) {
                            int_type* t1 = a->get_host_int_by_name(s2_val);
                            bool_vectors.push(host_compare(t,t1,cmp_type));
                        }
                        else {
                            float_type* t1 = a->get_host_float_by_name(s2_val);
                            bool_vectors.push(host_compare(t,t1,cmp_type));
                        };
                    }
                    */
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
                if(ss.compare("JOIN") == 0)
                    process_error(2, "operation = is not valid");
                //cout << "operation = is not valid" << endl;
                else
                    process_error(2, "operation " + string(ss)+ " is not valid");
                //cout << "operation " << ss << " is not valid" << endl;
                exit(0);	// never gets here
            }
        };
    };


    return bool_vectors.top();

}

