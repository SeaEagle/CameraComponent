//
//  ESColorUtil.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/26.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESColorUtil.h"

@implementation ESColorUtil

/*
 *
 * 注: 传进来的十六进制数值不需要前面的#
 *
 */
+ (UIColor *)getColorFromHexValue:(NSString *)hexColorValue{
    if( !hexColorValue || [hexColorValue isEqualToString:@""] ){
        return nil;
    }
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColorValue substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColorValue substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColorValue substringWithRange:range]]scanHexInt:&blue];
    
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    
    return color;
}

@end
