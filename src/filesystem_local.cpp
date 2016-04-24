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

#include "filesystem_local.h"

namespace alenka {

FileSystemLocal::FileSystemLocal() {

}

iFileSystemHandle* FileSystemLocal::open(const char* path, const char * mode) {
	FileSystemHandleLocal *h = new FileSystemHandleLocal;
	h->_file = fopen(path, "");
	return h;
}

size_t FileSystemLocal::read(void* buffer, size_t length, iFileSystemHandle * h) {
	return fread(buffer, length, 1, reinterpret_cast<FileSystemHandleLocal*>(h)->_file);
}

size_t FileSystemLocal::write(const void* buffer, size_t length, iFileSystemHandle * h) {
	return fwrite(buffer, sizeof(char), length, reinterpret_cast<FileSystemHandleLocal*>(h)->_file);
}

size_t FileSystemLocal::seek(iFileSystemHandle * h, size_t offset, int origin) {
	return fseek(reinterpret_cast<FileSystemHandleLocal*>(h)->_file, offset, origin);
}

size_t FileSystemLocal::tell(iFileSystemHandle * h) {
	return ftell(reinterpret_cast<FileSystemHandleLocal*>(h)->_file);
}

void FileSystemLocal::close(iFileSystemHandle * h) {
	fclose (reinterpret_cast<FileSystemHandleLocal*>(h)->_file);
}

int FileSystemLocal::remove(const char* path) {
	return remove(path);
}

int FileSystemLocal::rename(const char* oldPath, const char* newPath) {
	return rename(oldPath, newPath);
}

} // namespace alenka
