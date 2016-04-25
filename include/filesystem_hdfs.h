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

#ifndef FILESYSTEM_HDFS_H_
#define FILESYSTEM_HDFS_H_

#include "ifilesystem.h"

#include "hdfs.h"

namespace alenka {

class FileSystemHandleHDFS: public iFileSystemHandle
{
public:
	FileSystemHandleHDFS();
	hdfsFile _file;
	size_t _offset;
	size_t _size;
	const char* _path;
};

class FileSystemHDFS: public IFileSystem {
public:
	FileSystemHDFS(const char* host, tPort port, const char* base_path);
	FileSystemHDFS(const char* host, tPort port,  const char *user, const char* base_path);
	~FileSystemHDFS();
	iFileSystemHandle* open(const char* path, const char* mode);
	size_t read(void* buffer, size_t length, iFileSystemHandle* h);
	size_t write(const void* buffer, size_t length, iFileSystemHandle* h);
	size_t seek(iFileSystemHandle* h, size_t offset, int origin);
	size_t tell(iFileSystemHandle* h);
	size_t putc(int character, iFileSystemHandle* h);
	size_t puts(const char * str, iFileSystemHandle* h);
	size_t printf(iFileSystemHandle* h, const char * format, ...);
	void close(iFileSystemHandle* h);
	int remove(const char* path);
	int rename(const char* oldPath, const char* newPath);
	bool exist(const char* path);
private:
	hdfsFS _fs;
};


} // namespace alenka


#endif /* FILESYSTEM_HDFS_H_ */
