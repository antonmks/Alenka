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

#include "filesystem_hdfs.h"

namespace alenka {

FileSystemHDFS::FileSystemHDFS(const char* host, tPort port) {
	_fs = hdfsConnect(host, port);
}

FileSystemHDFS::~FileSystemHDFS(){
	hdfsDisconnect(_fs);
}

iFileSystemHandle* FileSystemHDFS::open(const char* path, const char * mode) {
	int bufferSize = 0;
	short replication = 0;
	tSize blocksize = 0;
	int flags = O_RDONLY;//FIXME

	HDFSFile *f = hdfsOpenFile(_fs, path, flags, bufferSize, replication, blocksize);
	if(!f)
		return NULL;

	FileSystemHandleHDFS *h = new FileSystemHandleHDFS;
	h->_file = f;
	return h;
}

size_t FileSystemHDFS::read(void* buffer, size_t length, iFileSystemHandle * h) {
	return hdfsRead(_fs, reinterpret_cast<FileSystemHandleHDFS*>(h)->_file, buffer, length);
}

size_t FileSystemHDFS::write(const void* buffer, size_t length, iFileSystemHandle * h) {
	return hdfsWrite(_fs, reinterpret_cast<FileSystemHandleHDFS*>(h)->_file, buffer, length);
}

size_t FileSystemHDFS::seek(iFileSystemHandle * h, size_t offset, int origin) {
	return hdfsSeek(_fs, reinterpret_cast<FileSystemHandleHDFS*>(h)->_file, offset);
}

size_t FileSystemHDFS::tell(iFileSystemHandle * h) {
	return hdfsTell(_fs, reinterpret_cast<FileSystemHandleHDFS*>(h)->_file);
}

size_t FileSystemHDFS::putc(int character, iFileSystemHandle* h){

}

size_t FileSystemLocal::puts(const char * str, iFileSystemHandle* h){
	//TODO
}

size_t FileSystemLocal::printf(iFileSystemHandle* h, const char * format, ...) {

}

void FileSystemHDFS::close(iFileSystemHandle * h) {
	hdfsCloseFile(_fs, reinterpret_cast<FileSystemHandleHDFS*>(h)->_file);
	delete h;
}

int FileSystemHDFS::remove(const char* path){
	 return hdfsDelete(_fs, path, 0);
}

int FileSystemHDFS::rename(const char* oldPath, const char* newPath){
	return hdfsRename(_fs, oldPath, newPath);
}

bool FileSystemHDFS::exist(const char* path){
    return hdfsExists(_fs, path);
}

} // namespace alenka
