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

#include <stdarg.h>
#include <string.h>

#include "log.h"
#include "filesystem_hdfs.h"

namespace alenka {

FileSystemHandleHDFS::FileSystemHandleHDFS() :
		_offset(0), _size(-1), _path(""), _file(NULL) {
}

FileSystemHDFS::FileSystemHDFS(const char* host, tPort port, const char* base_path) {
	_fs = hdfsConnect(host, port);
	hdfsSetWorkingDirectory(_fs, base_path);
}

FileSystemHDFS::FileSystemHDFS(const char* host, tPort port,  const char *user, const char* base_path) {
	_fs = hdfsConnectAsUser(host, port, user);
	hdfsSetWorkingDirectory(_fs, base_path);
	_base_path = base_path;
}

FileSystemHDFS::~FileSystemHDFS() {
	hdfsDisconnect(_fs);
}

iFileSystemHandle* FileSystemHDFS::open(const char* path, const char * mode) {
	int bufferSize = 0; //Default
	short replication = 0; //Default
	tSize blocksize = 0; //Default

	//build flags
	int flags = 0;
	for(int i = 0; mode[i]; i++){
		if(mode[i] == 'a'){
			flags |= O_APPEND;
		}else if(mode[i] == 't'){
			flags |= O_TRUNC;
		}else if(mode[i] == 'r'){
			flags |= O_RDONLY;
		}else if(mode[i] == 'w'){
			flags |= O_WRONLY;
		}
	}

	FileSystemHandleHDFS *h = new FileSystemHandleHDFS;
	h->_file = hdfsOpenFile(_fs, path, flags, bufferSize, replication, blocksize);
	return (!h->_file) ? NULL : h;
}

size_t FileSystemHDFS::read(void* buffer, size_t length, iFileSystemHandle* h) {
	FileSystemHandleHDFS * f = reinterpret_cast<FileSystemHandleHDFS*>(h);
	tSize num_read = hdfsPread(_fs, f->_file, f->_offset, buffer, length);
	f->_offset += length;
	return num_read;
}

size_t FileSystemHDFS::write(const void* buffer, size_t length, iFileSystemHandle* h) {
	return hdfsWrite(_fs, reinterpret_cast<FileSystemHandleHDFS*>(h)->_file, buffer, length);
}

size_t FileSystemHDFS::seek(iFileSystemHandle* h, long int offset, int origin) {
	FileSystemHandleHDFS * f = reinterpret_cast<FileSystemHandleHDFS*>(h);

	if (origin == SEEK_SET) {
		f->_offset = origin;
	} else if (origin == SEEK_CUR) {
		f->_offset += offset;
	} else if (origin == SEEK_END) {
		if (offset > 0) {
			LOG(logERROR) << "Unable to seek past end of file";
			return -1;
		}
		if (f->_size == -1) {
			hdfsFileInfo *info = hdfsGetPathInfo(_fs, f->_path);
			if (info != 0) {
				f->_size = info->mSize;
				hdfsFreeFileInfo(info, 1);
			} else {
				LOG(logERROR) << "Unable to seek past end of file";
				return -1;
			}
		}
		f->_offset = f->_size;
	} else {
		LOG(logERROR) << "Unknown seek origin!";
		return -1;
	}
	return f->_offset;
}

size_t FileSystemHDFS::tell(iFileSystemHandle* h) {
	FileSystemHandleHDFS * f = reinterpret_cast<FileSystemHandleHDFS*>(h);
	return f->_offset;
}

size_t FileSystemHDFS::putc(int character, iFileSystemHandle* h) {
	return write((void *)character, sizeof(int), h);
}

size_t FileSystemHDFS::puts(const char * str, iFileSystemHandle* h) {
	return write((void *)str, strlen(str), h);
}

size_t FileSystemHDFS::printf(iFileSystemHandle* h, const char * format, ...) {
	char buffer[256];
	va_list args;
	va_start(args, format);
	vsprintf(buffer, format, args);
	size_t ret = write(buffer, strlen(buffer), h);
	va_end(args);
	return ret;
}

void FileSystemHDFS::close(iFileSystemHandle* h) {
	hdfsCloseFile(_fs, reinterpret_cast<FileSystemHandleHDFS*>(h)->_file);
	delete h;
}

int FileSystemHDFS::remove(const char* path) {
	return hdfsDelete(_fs, path, 0);
}

int FileSystemHDFS::rename(const char* oldPath, const char* newPath) {
	return hdfsRename(_fs, oldPath, newPath);
}

bool FileSystemHDFS::exist(const char* path) {
	return hdfsExists(_fs, path);
}

} // namespace alenka
