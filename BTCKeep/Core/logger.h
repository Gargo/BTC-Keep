#ifndef _LOGGER_H
#define _LOGGER_H

#ifndef DEBUG
#define LOG(...)
#else
#define LOG(...) NSLog(__VA_ARGS__)
#endif

#endif
