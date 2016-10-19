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
	else
		if (column1 == 'N' || column2 == 'N') {
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
	else
		if (column1 == 'N' && column2 == 'N')
			return 'N';
		else
			return 'R';

}



char host_compare(int_type s, int_type d, int_type op_type)
{
	char res = 'N';

	if (op_type == 2 && d>s ) // >
		res = 'A';
	else
		if (op_type == 1 && d<s)  // <
			res = 'A';
		else
			if (op_type == 6 && d>=s) // >=
				res = 'A';
			else
				if (op_type == 5 && d<=s)  // <=
					res = 'A';
				else
					if (op_type == 4 && d==s)// =
						res = 'A';
					else // !=
						if(d!=s)
							res = 'A';

	return res;
}


char host_compare(float_type s, float_type d, int_type op_type)
{
	char res = 'N';

	if (op_type == 2 && (d-s) > EPSILON) // >
		res = 'A';
	else
		if (op_type == 1 && (s-d) > EPSILON)  // <
			res = 'A';
		else
			if (op_type == 6 && ((d-s) > EPSILON) || (((d-s) < EPSILON) && ((d-s) > -EPSILON))) // >=
				res = 'A';
			else
				if (op_type == 5 && ((s-d) > EPSILON) || (((d-s) < EPSILON) && ((d-s) > -EPSILON)))  // <=
					res = 'A';
				else
					if (op_type == 4 && ((d-s) < EPSILON) && ((d-s) > -EPSILON))// =
						res = 'A';
					else // !=
						if (!(((d-s) < EPSILON) && ((d-s) > -EPSILON)))
							res = 'A';

	return res;
}


char host_compare(int_type* column1, int_type d, int_type op_type)
{
	char res = 'R';

	//cout << "CMP " << column1[0] << " " << column1[1] << " " << d << " " << op_type << endl;

	if (op_type == 2) {   // >
		if (column1[1] <= d)
			res = 'N';
		else
			if (column1[0] > d)
				res = 'A';
	}
	else
		if (op_type == 1) { // <
			if (column1[0] >= d)
				res = 'N';
			else
				if (column1[1] < d)
					res = 'A';
		}
		else
			if (op_type == 6) {  // >=
				if (column1[1] < d)
					res = 'N';
				else
					if (column1[0] >= d)
						res = 'A';
			}
			else
				if (op_type == 5) { // <=
					if (column1[0] > d)
						res = 'N';
					else
						if (column1[1] <= d)
							res = 'A';
				}
				else
					if (op_type == 4 && column1[0] == d && column1[1] == d) { // =
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
		else
			if(fh_greater(column1[0],d)) {
				res = 'A';
			};
	}
	else
		if (op_type == 1) { // <
			if(fh_less(column1[1],d)) {
				res = 'A';
			}
			else
				if(fh_greater_equal_to(column1[0],d)) {
					res = 'N';
				};
		}
		else
			if (op_type == 6) { // >=
				if(fh_greater_equal_to(column1[0],d)) {
					res = 'A';
				}
				else
					if(fh_less(column1[1],d)) {
						res = 'N';
					};
			}
			else
				if (op_type == 5) { // <=
					if(fh_less_equal_to(column1[1],d)) {
						res = 'A';
					}
					else
						if(fh_greater(column1[0],d)) {
							res = 'N';
						};
				}
				else
					if (op_type == 4 && fh_equal_to(column1[0],d) && fh_equal_to(column1[1],d)) // =
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
		else
			if(column1[1] <= column2[0])
				res = 'N';
	}
	else
		if (op_type == 1) { // <
			if(column1[1] < column2[0])
				res = 'A';
			else
				if(column1[0] >= column2[1])
					res = 'N';
		}
		else
			if (op_type == 6) { // >=
				if(column1[0] >= column2[1])
					res = 'A';
				else
					if(column1[1] < column2[0])
						res = 'N';
			}
			else
				if (op_type == 5) { // <=
					if(column1[1] <= column2[0])
						res = 'A';
					else
						if(column1[0] > column2[1])
							res = 'N';
				}
				else
					if (op_type == 4  && column1[0] == column2[1] && column1[1] == column2[0]) // =
						res = 'A';

	return res;


}

char host_compare(float_type* column1, float_type* column2, int_type op_type)
{
	char res = 'R';

	if (op_type == 2) { // >
		if(fh_greater(column1[0],column2[1]))
			res = 'A';
		else
			if(fh_less_equal_to(column1[1],column2[0]))
				res = 'N';
	}
	else
		if (op_type == 1) { // <
			if(fh_less(column1[1],column2[0]))
				res = 'A';
			else
				if(fh_greater_equal_to(column1[0],column2[1]))
					res = 'N';
		}
		else
			if (op_type == 6) { // >=
				if(fh_greater_equal_to(column1[1],column2[0]))
					res = 'A';
				else
					if(fh_less(column1[1],column2[0]))
						res = 'N';
			}
			else
				if (op_type == 5) { // <=
					if(fh_less_equal_to(column1[1],column2[0]))
						res = 'A';
					else
						if(fh_greater(column1[0],column2[1]))
							res = 'N';
				}
				else
					if (op_type == 4  && fh_equal_to(column1[0], column2[1]) && fh_equal_to(column1[1],column2[0])) // =
						res = 'A';

	return res;
}


char host_compare(float_type* column1, int_type* column2, int_type op_type)
{
	char res = 'R';

	if (op_type == 2) { // >
		if(fh_greater(column1[0],(float_type)column2[1]))
			res = 'A';
		else
			if(fh_less_equal_to(column1[1],(float_type)column2[0]))
				res = 'N';
	}
	else
		if (op_type == 1) { // <
			if(fh_less(column1[1],(float_type)column2[0]))
				res = 'A';
			else
				if(fh_greater_equal_to(column1[0],(float_type)column2[1]))
					res = 'N';
		}
		else
			if (op_type == 6) { // >=
				if(fh_greater_equal_to(column1[1],(float_type)column2[0]))
					res = 'A';
				else
					if(fh_less(column1[1],(float_type)column2[0]))
						res = 'N';
			}
			else
				if (op_type == 5) { // <=
					if(fh_less_equal_to(column1[1],(float_type)column2[0]))
						res = 'A';
					else
						if(fh_greater(column1[0],(float_type)column2[1]))
							res = 'N';
				}
				else
					if (op_type == 4  && fh_equal_to(column1[0],(float_type) column2[1]) && fh_equal_to(column1[1],(float_type)column2[0])) // =
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
		else
			if (op_type.compare("ADD") == 0) {
				temp[0] = temp[0] + column2[0];
				temp[1] = temp[1] + column2[1];
			}
			else
				if (op_type.compare("MINUS") == 0) {
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
		else
			if (op_type.compare("ADD") == 0) {
				temp[0] = temp[0] + column2[0];
				temp[1] = temp[1] + column2[1];
			}
			else
				if (op_type.compare("MINUS") == 0) {
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
		else
			if (op_type.compare("ADD") == 0) {
				temp[0] = column1[0] + column2[0];
				temp[1] = column1[1] + column2[1];
			}
			else
				if (op_type.compare("MINUS") == 0) {
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
		else
			if (op_type.compare("ADD") == 0) {
				temp[0] = column1[0] + column2[0];
				temp[1] = column1[1] + column2[1];
			}
			else
				if (op_type.compare("MINUS") == 0) {
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
		else
			if (op_type.compare("ADD") == 0) {
				temp[0] = column1[0] + column2[0];
				temp[1] = column1[1] + column2[1];
			}
			else
				if (op_type.compare("MINUS") == 0) {
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
		else
			if (op_type.compare("ADD") == 0) {
				temp[0] = column1[0] + column2[0];
				temp[1] = column1[1] + column2[1];
			}
			else
				if (op_type.compare("MINUS") == 0) {
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
		else
			if (op_type.compare("ADD") == 0) {
				temp[0] = column1[0] + d;
				temp[1] = column1[1] + d;
			}
			else
				if (op_type.compare("MINUS") == 0) {
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
		else
			if (op_type.compare("ADD") == 0) {
				temp[0] = column1[0] + d;
				temp[1] = column1[1] + d;
			}
			else
				if (op_type.compare("MINUS") == 0) {
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
		else
			if (op_type.compare("ADD") == 0) {
				temp1[0] = temp[0] + d;
				temp1[1] = temp[1] + d;
			}
			else
				if (op_type.compare("MINUS") == 0) {
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
		else
			if (op_type.compare("ADD") == 0) {
				temp1[0] = temp[0] + d;
				temp1[1] = temp[1] + d;
			}
			else
				if (op_type.compare("MINUS") == 0) {
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
		else
			if (op_type.compare("ADD") == 0) {
				temp[0] = column1[0] + d;
				temp[1] = column1[1] + d;
			}
			else
				if (op_type.compare("MINUS") == 0) {
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
		else
			if (op_type.compare("ADD") == 0) {
				temp[0] = column1[0] + d;
				temp[1] = column1[1] + d;
			}
			else
				if (op_type.compare("MINUS") == 0) {
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
	stack<unsigned int> exe_precision;
	string  s1, s2, s1_val, s2_val;
	int_type n1, n2, res;

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
					fseek(f, 8+cnt, SEEK_CUR);
					fread((char *)&a->mRecCount, 4, 1, f);
					//cout << endl << "ZONE " << a->mRecCount << endl;
					fread((char *)&cnt, 4, 1, f);
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
		//cout << ss << endl;

		if (ss.compare("NAME") == 0 || ss.compare("NUMBER") == 0 || ss.compare("FLOAT") == 0
		        || ss.compare("STRING") == 0) {

			exe_type.push(ss);
			if (ss.compare("NUMBER") == 0) {
				exe_nums.push(op_nums.front());
				op_nums.pop();
				exe_precision.push(op_nums_precision.front());
				op_nums_precision.pop();
			}
			else
				if (ss.compare("NAME") == 0)  {
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
				else
					if (ss.compare("STRING") == 0) {
						exe_value.push(op_value.front());
						op_value.pop();
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
					else
						if (ss.compare("MUL") == 0 )
							res = n1*n2;
						else
							if (ss.compare("DIV") == 0 )
								res = n1/n2;
							else
								res = n1-n2;

					exe_type.push("NUMBER");
					exe_nums.push(res);
				}



				else
					if (s1.compare("NAME") == 0 && s2.compare("STRING") == 0) {
						s1_val = exe_value.top();
						exe_value.pop();
						s2_val = exe_value.top();
						exe_value.pop();
						int_type val;
						int_type* t = get_host_vec(a, s1_val, exe_vectors);


						exe_type.push("NAME");
						exe_value.push("");
						exe_precision.push(0);
					}
					else
						if (s2.compare("NAME") == 0 && s1.compare("STRING") == 0) {
							s1_val = exe_value.top();
							exe_value.pop();
							s2_val = exe_value.top();
							exe_value.pop();
							int_type val;
							int_type* t = get_host_vec(a, s2_val, exe_vectors);
							//cout << "name " << s2_val << endl;


							exe_type.push("NAME");
							exe_value.push("");
							exe_precision.push(0);
						}

						else
							if (s1.compare("NAME") == 0 && s2.compare("NUMBER") == 0) {
								s1_val = exe_value.top();
								exe_value.pop();
								n1 = exe_nums.top();
								exe_nums.pop();
								auto p2 = exe_precision.top();
								exe_precision.pop();
								auto p1 = get_decimals(a, s1_val, exe_precision);
								int_type* t = get_host_vec(a, s1_val, exe_vectors);
								auto pres = precision_func(p1, p2, ss);
								exe_precision.push(pres);
								if(p1) {
									t[0] = t[0]*(unsigned int)pow(10,p1);
									t[1] = t[1]*(unsigned int)pow(10,p1);
								};
								if(p2) {
									n1 = n1*(unsigned int)pow(10,p2);
								};

								exe_type.push("NAME");
								exe_value.push("");
								exe_vectors.push(host_op(t,n1,ss,1));

							}
							else
								if (s1.compare("NUMBER") == 0 && s2.compare("NAME") == 0) {
									n1 = exe_nums.top();
									exe_nums.pop();
									s2_val = exe_value.top();
									exe_value.pop();
									auto p2 = exe_precision.top();
									exe_precision.pop();
									auto p1 = get_decimals(a, s2_val, exe_precision);

									int_type* t = get_host_vec(a, s2_val, exe_vectors);
									auto pres = precision_func(p1, p2, ss);
									exe_precision.push(pres);
									if(p1) {
										t[0] = t[0]*(unsigned int)pow(10,p1);
										t[1] = t[1]*(unsigned int)pow(10,p1);
									};
									if(p2) {
										n1 = n1*(unsigned int)pow(10,p2);
									};

									exe_type.push("NAME");
									exe_value.push("");
									exe_vectors.push(host_op(t,n1,ss,0));

								}
								else
									if (s1.compare("NAME") == 0 && s2.compare("NAME") == 0) {

										s1_val = exe_value.top();
										exe_value.pop();
										s2_val = exe_value.top();
										exe_value.pop();

										auto p1 = get_decimals(a, s1_val, exe_precision);
										auto p2 = get_decimals(a, s2_val, exe_precision);

										int_type* t = get_host_vec(a, s1_val, exe_vectors);
										int_type* s3 = get_host_vec(a, s2_val, exe_vectors);;

										exe_type.push("NAME");
										exe_value.push("");
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
										if(std::find(a->columnNames.begin(), a->columnNames.end(), s1_val) == a->columnNames.end())
											delete [] t;
										if(std::find(a->columnNames.begin(), a->columnNames.end(), s2_val) == a->columnNames.end())
											delete [] s3;
									}
			}

			else
				if (ss.compare("CMP") == 0) {

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
						exe_type.push("NAME");
						exe_value.push("");

						if(p1)
							n1 = n1*(unsigned int)pow(10,pres-p1);
						if(p2)
							n2 = n2*(unsigned int)pow(10,pres-p2);
						bool_vectors.push(host_compare(n1,n2,cmp_type));
					}

					else
						if (s1.compare("STRING") == 0 && s2.compare("NAME") == 0) {
							time_t tt;
							s1_val = exe_value.top();
							exe_value.pop();
							s2_val = exe_value.top();
							exe_value.pop();
							int_type val;
							int_type* t = get_host_vec(a, s2_val, exe_vectors);
							auto pos = s1_val.find("date()");
							bool_vectors.push('R');
							exe_type.push("NAME");
							exe_value.push("");
						}
						else
							if (s1.compare("NAME") == 0 && s2.compare("STRING") == 0) {
								s2_val = exe_value.top();
								exe_value.pop();
								s1_val = exe_value.top();
								exe_value.pop();
								int_type val;
								time_t tt;
								int_type* t = get_host_vec(a, s1_val, exe_vectors);

								bool_vectors.push('R');
								exe_type.push("NAME");
								exe_value.push("");
							}

							else
								if (s1.compare("NUMBER") == 0 && s2.compare("NAME") == 0) {
									n1 = exe_nums.top();
									exe_nums.pop();
									s1_val = exe_value.top();
									exe_value.pop();
									auto p2 = exe_precision.top();
									exe_precision.pop();

									auto p1 = get_decimals(a, s1_val, exe_precision);
									int_type* t = get_host_vec(a, s1_val, exe_vectors);
									auto pres = std::max(p1, p2);
									exe_precision.push(pres);

									if(p1) {
										t[0] = t[0]*(unsigned int)pow(10,pres-p1);
										t[1] = t[1]*(unsigned int)pow(10,pres-p1);
									};
									if(p2) {
										n1 = n1*(unsigned int)pow(10,pres-p2);
									};
									exe_type.push("NAME");
									exe_value.push("");
									bool_vectors.push(host_compare(t,n1,cmp_type));
								}
								else
									if (s1.compare("NAME") == 0 && s2.compare("NUMBER") == 0) {
										cmp_type = reverse_op(cmp_type);
										n1 = exe_nums.top();
										exe_nums.pop();
										s2_val = exe_value.top();
										exe_value.pop();
										auto p2 = exe_precision.top();
										exe_precision.pop();
										auto p1 = get_decimals(a, s2_val, exe_precision);

										int_type* t = get_host_vec(a, s2_val, exe_vectors);
										auto pres = std::max(p1, p2);
										exe_precision.push(pres);
										if(p1) {
											t[0] = t[0]*(unsigned int)pow(10,pres-p1);
											t[1] = t[1]*(unsigned int)pow(10,pres-p1);
										};
										if(p2) {
											n1 = n1*(unsigned int)pow(10,pres-p2);
										};
										exe_type.push("NAME");
										exe_value.push("");
										bool_vectors.push(host_compare(t,n1,cmp_type));
									}

									else  {
										return 'R';
									}
				}

				else
					if (ss.compare("AND") == 0) {
						char s3 = bool_vectors.top();
						bool_vectors.pop();
						char s2 = bool_vectors.top();
						bool_vectors.pop();
						exe_type.push("NAME");
						bool_vectors.push(host_logical_and(s2,s3));
					}
					else
						if (ss.compare("OR") == 0) {
							char s3 = bool_vectors.top();
							bool_vectors.pop();
							char s2 = bool_vectors.top();
							bool_vectors.pop();
							exe_type.push("NAME");
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

