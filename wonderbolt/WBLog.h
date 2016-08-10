//
//  WBLog.h
//  wonderbolt
//
//  
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#ifndef Wonderbolt_WBLog_h
#define Wonderbolt_WBLog_h

//CLSNSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)

#ifdef DEBUG

#ifdef SV_NSLOGGER_ENABLED

#import "LoggerClient.h"

#if defined(DEBUG) && !defined(NDEBUG)
#undef assert
#if __DARWIN_UNIX03
#define assert(e) \
(__builtin_expect(!(e), 0) ? (CFShow(CFSTR("assert going to fail, connect NSLogger NOW\n")), LoggerFlush(NULL,YES), __assert_rtn(__func__, __FILE__, __LINE__, #e)) : (void)0)
#else
#define assert(e)  \
(__builtin_expect(!(e), 0) ? (CFShow(CFSTR("assert going to fail, connect NSLogger NOW\n")), LoggerFlush(NULL,YES), __assert(#e, __FILE__, __LINE__)) : (void)0)
#endif
#endif


#define WBLOG(...)    LogMessageCompat(__VA_ARGS__)
#define WBLOG_INFO(level, ...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"info",level,__VA_ARGS__)
#define WBLOG_NETWORK(level, ...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"network",level,__VA_ARGS__)
#define WBLOG_DATA(level, ...)   LogDataF(__FILE__,__LINE__,__FUNCTION__,@"data",level,__VA_ARGS__)
#define WBLOG_IMAGE(level,img)   LogImageDataF(__FILE__,__LINE__,__FUNCTION__,@"image",level,img.size.width, img.size.height,UIImagePNGRepresentation(img))
#define WBLOG_MARKER(txt)    LogMarker(txt)

#else

#define WBLOG(...)    NSLog(__VA_ARGS__)
#define WBLOG_INFO(level, ...)    NSLog(__VA_ARGS__)
#define WBLOG_NETWORK(level, ...)    NSLog(__VA_ARGS__)
#define WBLOG_DATA(level, ...)   NSLog(__VA_ARGS__)
#define WBLOG_IMAGE(level, ...)   NSLog(__VA_ARGS__)
#define WBLOG_MARKER(txt)    NSLog(txt)

#endif

#else

#define WBLOG(...)    do{}while(0)
#define WBLOG_INFO(...)    do{}while(0)
#define WBLOG_NETWORK(...)    do{}while(0)
#define WBLOG_DATA(...)    do{}while(0)
#define WBLOG_IMAGE(...)    do{}while(0)
#define WBLOG_MARKER(...)    do{}while(0)

#endif

#define WBLOG1_INFO(...)    WBLOG_INFO(1,__VA_ARGS__)
#define WBLOG1_NETWORK(...)    WBLOG_NETWORK(1,__VA_ARGS__)
#define WBLOG1_DATA(...)    WBLOG_DATA(1,__VA_ARGS__)
#define WBLOG1_IMAGE(img)   WBLOG_IMAGE(1,img)
#define WBLOG1_MARKER(txt)    WBLOG_MARKER(txt)

#endif