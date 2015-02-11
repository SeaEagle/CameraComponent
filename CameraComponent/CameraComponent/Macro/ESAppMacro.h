//
//  ESAppMacro.h
//  waiqin
//
//  Created by patinong on 15/1/10.
//  Copyright (c) 2015年 zengxl. All rights reserved.
//

#ifndef waiqin_ESAppMacro_h
#define waiqin_ESAppMacro_h

#define ApplicationDelegate ((ESAppDelegate *)[UIApplication sharedApplication].delegate)

#define SERVER_URL @"http://14.31.15.122:8080/?" //测试环境

#define deviceWidth [UIScreen mainScreen].bounds.size.width
#define deviceHeight [UIScreen mainScreen].bounds.size.height

#define navigationHeight 44
#define tabBarHeight 49
#define deltaHeight (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)? 20 : 0)

#define mainColor [UIColor colorWithRed:0/255.0f green:166/255.0f blue:233/255.0f alpha:1.0f]



#endif
