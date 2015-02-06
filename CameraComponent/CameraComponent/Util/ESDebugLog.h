//
//  ESDebugLog.h
//  waiqin
//
//  Created by zengxl on 15/1/14.
//  Copyright (c) 2015年 zengxl. All rights reserved.
//

#ifndef waiqin_ESDebugLog_h
#define waiqin_ESDebugLog_h

#define ESWQDEBUG
#define ESWQLOGLEVEL_INFO     10
#define ESWQLOGLEVEL_WARNING  3
#define ESWQLOGLEVEL_ERROR    1

#ifndef ESWQMAXLOGLEVEL
   //如果开启debug模式，日志级别最高为10，否则为1，只显示error
   #ifdef DEBUG
     #define ESWQMAXLOGLEVEL ESWQLOGLEVEL_INFO
   #else
     #define ESWQMAXLOGLEVEL ESWQLOGLEVEL_ERROR
   #endif
#endif


#ifdef ESWQDEBUG
  #define ESWQPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
  #define ESWQPRINT(xx, ...)  ((void)0)
#endif

//输出当前方法名
#define ESWQPRINTMETHODNAME() ESWQPRINT(@"%s", __PRETTY_FUNCTION__)

//根据宏定义来显示日志级别
#if ESWQLOGLEVEL_ERROR <= ESWQMAXLOGLEVEL
   #define ESWQERROR(xx, ...)  ESWQPRINT(xx, ##__VA_ARGS__)
#else
   #define ESWQERROR(xx, ...)  ((void)0)
#endif

#if ESWQLOGLEVEL_WARNING <= ESWQMAXLOGLEVEL
   #define ESWQWARNING(xx, ...)  ESWQPRINT(xx, ##__VA_ARGS__)
#else
   #define ESWQWARNING(xx, ...)  ((void)0)
#endif

#if ESWQLOGLEVEL_INFO <= ESWQMAXLOGLEVEL
   #define ESWQINFO(xx, ...)  ESWQPRINT(xx, ##__VA_ARGS__)
#else
   #define ESWQINFO(xx, ...)  ((void)0)
#endif

#ifdef ESWQDEBUG
   #define ESWQCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
ESWQPRINT(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
   #define ESWQCONDITIONLOG(condition, xx, ...) ((void)0)
#endif

#endif
