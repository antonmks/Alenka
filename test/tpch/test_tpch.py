import shutil
import os
import pytest
import subprocess
import difflib

@pytest.mark.incremental
class TestTPCH:

	def test_check_testdir(self, testdir):
		#clean up test dir
		for the_file in os.listdir(str(testdir.realpath())):
			file_path = os.path.join(str(testdir.realpath()), the_file)
			if os.path.isfile(file_path):
				os.unlink(file_path)

	def test_alenka(self, testdir):
		if not os.path.exists("../src/alenka"):
			raise Exception('missing src/alenka') 

		shutil.copy2("../src/alenka", str(testdir.realpath()))

	def test_cp_load(self, testdir):
		shutil.copy2("tpch/load/load_customer.sql", str(testdir.realpath()))
		shutil.copy2("tpch/load/load_lineitem.sql", str(testdir.realpath()))
		shutil.copy2("tpch/load/load_nation.sql", str(testdir.realpath()))
		shutil.copy2("tpch/load/load_orders.sql", str(testdir.realpath()))
		shutil.copy2("tpch/load/load_part.sql", str(testdir.realpath()))
		shutil.copy2("tpch/load/load_partsupp.sql", str(testdir.realpath()))
		shutil.copy2("tpch/load/load_region.sql", str(testdir.realpath()))
		shutil.copy2("tpch/load/load_supplier.sql", str(testdir.realpath()))

	def test_cp_data(self, testdir):
		shutil.copy2("tpch/data/customer.tbl", str(testdir.realpath()))
		shutil.copy2("tpch/data/lineitem.tbl", str(testdir.realpath()))
		shutil.copy2("tpch/data/nation.tbl", str(testdir.realpath()))
		shutil.copy2("tpch/data/orders.tbl", str(testdir.realpath()))
		shutil.copy2("tpch/data/part.tbl", str(testdir.realpath()))
		shutil.copy2("tpch/data/partsupp.tbl", str(testdir.realpath()))
		shutil.copy2("tpch/data/region.tbl", str(testdir.realpath()))
		shutil.copy2("tpch/data/supplier.tbl", str(testdir.realpath()))

	def test_cp_query(self, testdir):
		shutil.copy2("tpch/query/q1.sql", str(testdir.realpath()))
		shutil.copy2("tpch/query/q2.sql", str(testdir.realpath()))
		shutil.copy2("tpch/query/q3.sql", str(testdir.realpath()))
		shutil.copy2("tpch/query/q4.sql", str(testdir.realpath()))
		shutil.copy2("tpch/query/q5.sql", str(testdir.realpath()))
		shutil.copy2("tpch/query/q6.sql", str(testdir.realpath()))
		shutil.copy2("tpch/query/q7.sql", str(testdir.realpath()))
		shutil.copy2("tpch/query/q9.sql", str(testdir.realpath()))
		shutil.copy2("tpch/query/q10.sql", str(testdir.realpath()))

	def test_cp_result(self, testdir):
		shutil.copy2("tpch/result/q1.result.txt", str(testdir.realpath()))
		#shutil.copy2("tpch/result/q2.result.txt", str(testdir.realpath()))
		shutil.copy2("tpch/result/q3.result.txt", str(testdir.realpath()))
		#shutil.copy2("tpch/result/q4.result.txt", str(testdir.realpath()))
		shutil.copy2("tpch/result/q5.result.txt", str(testdir.realpath()))
		shutil.copy2("tpch/result/q6.result.txt", str(testdir.realpath()))
		#shutil.copy2("tpch/result/q7.result.txt", str(testdir.realpath()))
		#shutil.copy2("tpch/result/q9.result.txt", str(testdir.realpath()))
		shutil.copy2("tpch/result/q10.result.txt", str(testdir.realpath()))

	def test_chdir(self, testdir):
		os.chdir(str(testdir.realpath()))

	def test_load_tpch_customer(self):
		if subprocess.call(["alenka", "load_customer.sql"]) != 0:
			raise Exception('load error')

	def test_load_tpch_lineitem(self):
		if subprocess.call(["alenka", "load_lineitem.sql"]) != 0:
			raise Exception('load error')

	def test_load_tpch_nation(self):
		if subprocess.call(["alenka", "load_nation.sql"]) != 0:
			raise Exception('load error')

	def test_load_tpch_orders(self):
		if subprocess.call(["alenka", "load_orders.sql"]) != 0:
			raise Exception('load error')

	def test_load_tpch_part(self):
		if subprocess.call(["alenka", "load_part.sql"]) != 0:
			raise Exception('load error')

	def test_load_tpch_partsupp(self):
		if subprocess.call(["alenka", "load_partsupp.sql"]) != 0:
			raise Exception('load error')

	def test_load_tpch_part(self):
		if subprocess.call(["alenka", "load_part.sql"]) != 0:
			raise Exception('load error')

	def test_load_tpch_region(self):
		if subprocess.call(["alenka", "load_region.sql"]) != 0:
			raise Exception('load error')

	def test_load_tpch_supplier(self):
		if subprocess.call(["alenka", "load_supplier.sql"]) != 0:
			raise Exception('load error')

	def test_query_q1(self):
		if subprocess.call(["alenka", "q1.sql"]) != 0:
			raise Exception('query error')
	
		r1 = open('q1.result.txt', 'r')
		r2 = open('q1.txt', 'r')
                if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()
		
##	def test_query_q2(s2elf):
#		if subprocess.call(["alenka", "q2.sql"]) != 0:
#			raise Exception('query error')
#
#		r1 = open('q2.result.txt', 'r')
#		r2 = open('q2.txt', 'r')
#		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
#                       raise Exception('query results dont match!')
#		r1.close()
#		r2.close()

	def test_query_q3(self):
		if subprocess.call(["alenka", "q3.sql"]) != 0:
			raise Exception('query error')

		r1 = open('q3.result.txt', 'r')
		r2 = open('q3.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

#	def test_query_q4(self):
#		if subprocess.call(["alenka", "q4.sql"]) != 0:
#			raise Exception('query error')
#
#		r1 = open('q4.result.txt', 'r')
#		r2 = open('q4.txt', 'r')
#		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
#                        raise Exception('query results dont match!')
#
#		r1.close()
#		r2.close()

	def test_query_q5(self):
		if subprocess.call(["alenka", "q5.sql"]) != 0:
			raise Exception('query error')

		r1 = open('q5.result.txt', 'r')
		r2 = open('q5.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

	def test_query_q6(self):
		if subprocess.call(["alenka", "q6.sql"]) != 0:
			raise Exception('query error')

		r1 = open('q6.result.txt', 'r')
		r2 = open('q6.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

#	def test_query_a7(self):
#		if subprocess.call(["alenka", "a7.sql"]) != 0:
#			raise Exception('query error')
#
#		r1 = open('q7.result.txt', 'r')
#		r2 = open('q7.txt', 'r')
#		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
#                        raise Exception('query results dont match!')
#
#
#		r1.close()
#		r2.close()
#
#	def test_query_q9(self,):
#		if subprocess.call(["alenka", "q9.sql"]) != 0:
#			raise Exception('query error')
#
#		r1 = open('q9.result.txt', 'r')
#		r2 = open('q9.txt', 'r')
#		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
#                        raise Exception('query results dont match!')
#
#		r1.close()
#		r2.close()

	def test_query_q10(self):
		if subprocess.call(["alenka", "q10.sql"]) != 0:
			raise Exception('query error')

		r1 = open('q10.result.txt', 'r')
		r2 = open('q10.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

