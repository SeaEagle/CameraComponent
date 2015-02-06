//
//  ESFileTransferClient.h
//  waiqin
//
//  Created by zengxl on 15/1/22.
//  Copyright (c) 2015年 zengxl. All rights reserved.
//

#import "AFNetworking.h"

@interface ESFileTransferClient : AFURLSessionManager

typedef void (^CurrencyJsonResponseBlock)(NSDictionary *dictionary);

+(ESFileTransferClient*)sharedFileTransClient;
-(NSURLSessionDownloadTask *)downLoad:(NSString *)url params:(NSProgress *)progress
                    onCompletion:(CurrencyJsonResponseBlock) responseBlock
                         onError:(NSError*) errorBlock;
-(NSURLSessionUploadTask *)postJson:(NSURLRequest *)request fromFile:(NSURL*)url params:(NSProgress *)progress
                       onCompletion:(CurrencyJsonResponseBlock) responseBlock
                            onError:(NSError*) errorBlock;

@end
