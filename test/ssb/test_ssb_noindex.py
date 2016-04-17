import shutil
import os
import pytest
import subprocess

@pytest.mark.incremental
class TestSSBNoIndex:

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

	def test_cp_data(self, testdir):
		shutil.copy2("ssb/data/customer.tbl", str(testdir.realpath()))
		shutil.copy2("ssb/data/date.tbl", str(testdir.realpath()))
		shutil.copy2("ssb/data/lineorder.tbl", str(testdir.realpath()))
		shutil.copy2("ssb/data/part.tbl", str(testdir.realpath()))
		shutil.copy2("ssb/data/supplier.tbl", str(testdir.realpath()))

	def test_cp_query(self, testdir):
		shutil.copy2("ssb/query/noindex/ss11.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/noindex/ss12.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/noindex/ss13.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/noindex/ss21.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/noindex/ss22.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/noindex/ss23.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/noindex/ss31.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/noindex/ss32.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/noindex/ss33.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/noindex/ss34.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/noindex/ss41.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/noindex/ss42.sql", str(testdir.realpath()))
		shutil.copy2("ssb/query/noindex/ss43.sql", str(testdir.realpath()))

	def test_cp_result(self, testdir):
		shutil.copy2("ssb/result/ss11.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss12.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss13.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss21.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss22.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss23.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss31.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss32.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss33.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss34.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss41.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss42.txt", str(testdir.realpath()))
		shutil.copy2("ssb/result/ss43.txt", str(testdir.realpath()))

	def test_chdir(self, testdir):
		os.chdir(str(testdir.realpath()))

	def test_load_ssb_customer(self, testdir):
		if subprocess.call(["alenka", "load_customer.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_date(self, testdir):
		if subprocess.call(["alenka", "load_date.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_lineorder(self, testdir):
		if subprocess.call(["alenka", "load_lineorder.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_part(self, testdir):
		if subprocess.call(["alenka", "load_part.sql"]) != 0:
			raise Exception('load error')

	def test_load_ssb_supplier(self, testdir):
		if subprocess.call(["alenka", "load_supplier.sql"]) != 0:
			raise Exception('load error')

	def test_query_ss11(self, testdir):
		if subprocess.call(["alenka", "ss11.sql"]) != 0:
			raise Exception('query error')
	
		result1 = open('ss11.txt', 'r')
		result2 = open('ss11.txt2', 'r')
		diff = difflib.SequenceMatcher(None, result1.read(), result2.read())
		print diff
		assert 1
		
	def test_query_ss12(self, testdir):
		assert 0
		print subprocess.call(["alenka", "ss12.sql"])

	def test_query_ss13(self, testdir):
		print subprocess.call(["alenka", "ss13.sql"])

	def test_query_ss21(self, testdir):
		print subprocess.call(["alenka", "ss21.sql"])

	def test_query_ss22(self, testdir):
		print subprocess.call(["alenka", "ss22.sql"])

	def test_query_ss23(self, testdir):
		print subprocess.call(["alenka", "ss23.sql"])

	def test_query_ss31(self, testdir):
		print subprocess.call(["alenka", "ss31.sql"])

	def test_query_ss32(self, testdir):
		print subprocess.call(["alenka", "ss32.sql"])

	def test_query_ss33(self, testdir):
		print subprocess.call(["alenka", "ss33.sql"])

	def test_query_ss34(self, testdir):
		print subprocess.call(["alenka", "ss34.sql"])

	def test_query_ss41(self, testdir):
		print subprocess.call(["alenka", "ss41.sql"])

	def test_query_ss42(self, testdir):
		print subprocess.call(["alenka", "ss42.sql"])

	def test_query_ss43(self, testdir):
		print subprocess.call(["alenka", "ss43.sql"])

