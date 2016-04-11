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

#ifndef __LOG_H__
#define __LOG_H__

#include <sstream>
#include <string>
#include <stdio.h>

namespace alenka {

inline std::string NowTime();

enum TLogLevel {logERROR, logWARNING, logINFO, logDEBUG, logDEBUG1, logDEBUG2, logDEBUG3, logDEBUG4};

class Log {
public:
    Log();
    virtual ~Log();
    std::ostringstream& Get(TLogLevel level = logINFO);
    static TLogLevel& ReportingLevel();
    static std::string ToString(TLogLevel level);
    static TLogLevel FromString(const std::string& level);
protected:
    std::ostringstream os;
private:
    Log(const Log&);
    Log& operator =(const Log&);
};

inline Log::Log() {
}

inline std::ostringstream& Log::Get(TLogLevel level) {
    os << "- " << NowTime();
    os << " " << ToString(level) << ": ";
    os << std::string(level > logDEBUG ? level - logDEBUG : 0, '\t');
    return os;
}

inline Log::~Log() {
    os << std::endl;
    fprintf(stderr, "%s", os.str().c_str());
    fflush(stderr);
}

inline TLogLevel& Log::ReportingLevel() {
    static TLogLevel reportingLevel = logDEBUG4;
    return reportingLevel;
}

inline std::string Log::ToString(TLogLevel level) {
	static const char* const buffer[] = {"ERROR", "WARNING", "INFO", "DEBUG", "DEBUG1", "DEBUG2", "DEBUG3", "DEBUG4"};
    return buffer[level];
}

inline TLogLevel Log::FromString(const std::string& level) {
    if (level == "DEBUG4")
        return logDEBUG4;
    if (level == "DEBUG3")
        return logDEBUG3;
    if (level == "DEBUG2")
        return logDEBUG2;
    if (level == "DEBUG1")
        return logDEBUG1;
    if (level == "DEBUG")
        return logDEBUG;
    if (level == "INFO")
        return logINFO;
    if (level == "WARNING")
        return logWARNING;
    if (level == "ERROR")
        return logERROR;
    Log().Get(logWARNING) << "Unknown logging level '" << level << "'. Using INFO level as default.";
    return logINFO;
}

typedef Log LOG;

#define LOG(level) \
    if (level > LOG::ReportingLevel()) ; \
    else Log().Get(level)

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__)

#include <windows.h>

inline std::string NowTime() {
    const int MAX_LEN = 200;
    char buffer[MAX_LEN];
    if (GetTimeFormatA(LOCALE_USER_DEFAULT, 0, 0,
            "HH':'mm':'ss", buffer, MAX_LEN) == 0)
        return "Error in NowTime()";

    char result[100] = {0};
    static DWORD first = GetTickCount();
    std::sprintf(result, "%s.%03ld", buffer, (long)(GetTickCount() - first) % 1000);
    return result;
}

#else

#include <sys/time.h>

inline std::string NowTime() {
	struct timeval tv;
	struct tm ts;
	char result[32];

	gettimeofday(&tv, 0);
	localtime_r(&tv.tv_sec, &ts);
	sprintf(result, "%04d-%02d-%02d %02d:%02d:%02d.%03d", ts.tm_year+1900, ts.tm_mon+1, ts.tm_mday, ts.tm_hour, ts.tm_min, ts.tm_sec, (int)tv.tv_usec/1000);
	return (std::string)result;
}

#endif //WIN32

} // namespace alenka

#endif //__LOG_H__
