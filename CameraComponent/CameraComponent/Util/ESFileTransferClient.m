//
//  ESFileTransferClient.m
//  waiqin
//
//  Created by zengxl on 15/1/22.
//  Copyright (c) 2015年 zengxl. All rights reserved.
//

#import "ESFileTransferClient.h"

@implementation ESFileTransferClient

+(ESFileTransferClient*)sharedFileTransClient{
    static ESFileTransferClient *_sharedFileTransClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{@"":@""}];
        
        //设置我们的缓存大小 其中内存缓存大小设置10M 磁盘缓存5M
        NSURLCache *cache = [[NSURLCache alloc]initWithMemoryCapacity:10*1024*1024 diskCapacity:5*1024*1024 diskPath:nil];
        [config setURLCache:cache];
        _sharedFileTransClient = [[ESFileTransferClient alloc] initWithSessionConfiguration:config];
        _sharedFileTransClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedFileTransClient;
}

-(NSURLSessionDownloadTask *)downLoad:(NSURLRequest *)request params:(NSProgress *)progress
                    onCompletion:(CurrencyJsonResponseBlock) responseBlock
                         onError:(NSError*) errorBlock
{
    NSURLSessionDownloadTask *task = [self downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)  {
        
       NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
       return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
    }];
    return task;
}

-(NSURLSessionUploadTask *)postJson:(NSURLRequest *)request fromFile:(NSURL*)url params:(NSProgress *)progress
                     onCompletion:(CurrencyJsonResponseBlock) responseBlock
                          onError:(NSError*) errorBlock
{
    NSURLSessionUploadTask *task = [self uploadTaskWithRequest:request fromFile:url progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    
    return task;
}

@end
