import shutil
import os
import pytest
import subprocess

@pytest.mark.incremental
class TestSSBBitmapIndex:

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
		shutil.copy2("ssb/load/load_customer.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/load_date.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/load_lineorder.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/load_part.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/load_supplier.sql", str(testdir.realpath()))

	def test_cp_load_index(self, testdir):
		shutil.copy2("ssb/load/bitmapindex/index2.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/bitmapindex/index3.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/bitmapindex/index4.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/bitmapindex/index5.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/bitmapindex/index6.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/bitmapindex/index7.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/bitmapindex/index8.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/bitmapindex/index9.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/bitmapindex/index10.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/bitmapindex/index11.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/bitmapindex/index12.sql", str(testdir.realpath()))
		shutil.copy2("ssb/load/bitmapindex/index13.sql", str(testdir.realpath()))

	def test_cp_data(self, testdir):
		shutil.copy2("ssb/data/customer.tbl", str(testdir.realpath()))
		shutil.copy2("ssb/data/date.tbl", str(testdir.realpath()))
		shutil.copy2("ssb/data/lineorder.tbl", str(testdir.realpath()))
		shutil.copy2("ssb/data/part.tbl", str(testdir.realpath()))
		shutil.copy2("ssb/data/supplier.tbl", str(testdir.realpath()))

	def test_cp_query(self, testdir):
		shutil.copy2("ssb/query/bitmapindex/ss11.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/bitmapindex/ss12.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/bitmapindex/ss13.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/bitmapindex/ss21.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/bitmapindex/ss22.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/bitmapindex/ss23.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/bitmapindex/ss31.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/bitmapindex/ss32.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/bitmapindex/ss33.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/bitmapindex/ss34.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/bitmapindex/ss41.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/bitmapindex/ss42.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/bitmapindex/ss43.sql", str(testdir.realpath()))

	def test_cp_result(self, testdir):
		shutil.copy2("ssb/result/ss11.result.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss12.result.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss13.result.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss21.result.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss22.result.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss23.result.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss31.result.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss32.result.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss33.result.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss34.result.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss41.result.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss42.result.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss43.result.txt", str(testdir.realpath()))

	def test_chdir(self, testdir):
		os.chdir(str(testdir.realpath()))

	def test_load_ssb_customer(self):
		if subprocess.call(["alenka", "load_customer.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_date(self):
		if subprocess.call(["alenka", "load_date.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_lineorder(self):
		if subprocess.call(["alenka", "load_lineorder.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_part(self):
		if subprocess.call(["alenka", "load_part.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_supplier(self):
		if subprocess.call(["alenka", "load_supplier.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_index2(self):
		if subprocess.call(["alenka", "index2.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_index3(self):
		if subprocess.call(["alenka", "index3.sql"]) != 0:
			raise Exception('load error')
	
	def test_load_ssb_index4(self):
		if subprocess.call(["alenka", "index4.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_index5(self):
		if subprocess.call(["alenka", "index5.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_index6(self):
		if subprocess.call(["alenka", "index7.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_index8(self):
		if subprocess.call(["alenka", "index8.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_index9(self):
		if subprocess.call(["alenka", "index9.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_index10(self):
		if subprocess.call(["alenka", "index10.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_index11(self):
		if subprocess.call(["alenka", "index11.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_index12(self):
		if subprocess.call(["alenka", "index12.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_index13(self):
		if subprocess.call(["alenka", "index13.sql"]) != 0:
			raise Exception('load error')

	def test_query_ss11(self):
		if subprocess.call(["alenka", "ss11.sql"]) != 0:
			raise Exception('query error')
	
		r1 = open('ss11.result.txt', 'r')
		r2 = open('ss11.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()
		
	def test_query_ss12(self):
		if subprocess.call(["alenka", "ss12.sql"]) != 0:
			raise Exception('query error')

		r1 = open('ss12.result.txt', 'r')
		r2 = open('ss12.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

	def test_query_ss13(self):
		if subprocess.call(["alenka", "ss13.sql"]) != 0:
			raise Exception('query error')

		r1 = open('ss13.result.txt', 'r')
		r2 = open('ss13.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

	def test_query_ss21(self):
		if subprocess.call(["alenka", "ss21.sql"]) != 0:
			raise Exception('query error')

		r1 = open('ss21.result.txt', 'r')
		r2 = open('ss21.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

	def test_query_ss22(self):
		if subprocess.call(["alenka", "ss22.sql"]) != 0:
			raise Exception('query error')

		r1 = open('ss22.result.txt', 'r')
		r2 = open('ss22.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

	def test_query_ss23(self):
		if subprocess.call(["alenka", "ss23.sql"]) != 0:
			raise Exception('query error')

		r1 = open('ss23.result.txt', 'r')
		r2 = open('ss23.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

	def test_query_ss31(self):
		if subprocess.call(["alenka", "ss31.sql"]) != 0:
			raise Exception('query error')

		r1 = open('ss31.result.txt', 'r')
		r2 = open('ss31.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

	def test_query_ss32(self,):
		if subprocess.call(["alenka", "ss32.sql"]) != 0:
			raise Exception('query error')

		r1 = open('ss32.result.txt', 'r')
		r2 = open('ss32.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

	def test_query_ss33(self):
		if subprocess.call(["alenka", "ss33.sql"]) != 0:
			raise Exception('query error')

		r1 = open('ss33.result.txt', 'r')
		r2 = open('ss33.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

	def test_query_ss34(self):
		if subprocess.call(["alenka", "ss34.sql"]) != 0:
			raise Exception('query error')

		r1 = open('ss34.result.txt', 'r')
		r2 = open('ss34.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

	def test_query_ss41(self):
		if subprocess.call(["alenka", "ss41.sql"]) != 0:
			raise Exception('query error')

		r1 = open('ss41.result.txt', 'r')
		r2 = open('ss41.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

	def test_query_ss42(self):
		if subprocess.call(["alenka", "ss42.sql"]) != 0:
			raise Exception('query error')

		r1 = open('ss42.result.txt', 'r')
		r2 = open('ss42.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

	def test_query_ss43(self):
		if subprocess.call(["alenka", "ss43.sql"]) != 0:
			raise Exception('query error')

		r1 = open('ss43.result.txt', 'r')
		r2 = open('ss43.txt', 'r')
		if r1.read().strip('\n\r') != r2.read().strip('\n\r'):
                        raise Exception('query results dont match!')

		r1.close()
		r2.close()

