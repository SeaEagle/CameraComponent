//
//  ESUrlImageCache.m
//  CameraComponent
//
//  Created by ElogisticsBase on 15/3/11.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESUrlImageCache.h"

@implementation ESUrlImageCache

+ (UIImage *)getImageWithUrl:(NSString *)imageUrl{
    //
    if( nil == urlImageCache ){
        urlImageCache = [[NSMutableDictionary alloc]init];
        NSLog(@"-----------------------init-----------------------Size: %ld", [urlImageCache count]);
    }
    //
    UIImage *image;
    if ( [[urlImageCache allKeys]containsObject:imageUrl] ) {
        NSLog(@"get image: %@", imageUrl);
        image = [urlImageCache objectForKey:imageUrl];
    }else if( [[imageUrl lowercaseString] hasSuffix:@"jpeg"] || [[imageUrl lowercaseString] hasSuffix:@"png"] || [[imageUrl lowercaseString] hasSuffix:@"jpg"] ){
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        NSLog(@"set image: %@ image: %@", imageUrl, image);
        if ( nil != image ) {
            [urlImageCache setObject:image forKey:imageUrl];
        }
    }else{
        image = nil;
    }
    //
    return image;
}

@end
