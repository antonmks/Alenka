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

#ifndef FILESYSTEM_LOCAL_H_
#define FILESYSTEM_LOCAL_H_

#include "ifilesystem.h"

#include <stdio.h>

namespace alenka {

class FileSystemHandleLocal: public iFileSystemHandle
{
public:
	FILE * _file;
};

class FileSystemLocal: public IFileSystem {
public:
	FileSystemLocal();
	iFileSystemHandle* open(const char* path, const char * mode);
	size_t read(void* buffer, size_t length, iFileSystemHandle * h);
	size_t write(const void* buffer, size_t length, iFileSystemHandle * h);
	size_t seek(iFileSystemHandle * h, size_t offset, int origin);
	size_t tell(iFileSystemHandle * h);
	void close(iFileSystemHandle * h);
	int remove(const char* path);
	int rename(const char* oldPath, const char* newPath);
};

} // namespace alenka

#endif /* FILESYSTEM_LOCAL_H_ */
