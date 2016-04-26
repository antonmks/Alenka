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

#ifndef IFILESYSTEM_H_
#define IFILESYSTEM_H_

#include <cstddef>

using namespace std;

namespace alenka {

class iFileSystemHandle {
};

class IFileSystem {
public:
	virtual ~IFileSystem() {}
	virtual iFileSystemHandle* open(const char* path, const char* mode) = 0;
	virtual size_t read(void* buffer, size_t length, iFileSystemHandle* h) = 0;
	virtual size_t write(const void* buffer, size_t length, iFileSystemHandle* h) = 0;
	virtual size_t seek(iFileSystemHandle* h, long int offset, int origin) = 0;
	virtual size_t tell(iFileSystemHandle* h) = 0;
	virtual size_t putc(int character, iFileSystemHandle* h) = 0;
	virtual size_t puts(const char * str, iFileSystemHandle* h) = 0;
	virtual size_t printf(iFileSystemHandle* h, const char * format, ...) = 0;
	virtual void close(iFileSystemHandle* h) = 0;
	virtual int remove(const char* path) = 0;
	virtual int rename(const char* oldPath, const char* newPath) = 0;
	virtual bool exist(const char* path) = 0;
protected:
	const char* _base_path;
};

} // namespace alenka

#endif /* IFILESYSTEM_H_ */
