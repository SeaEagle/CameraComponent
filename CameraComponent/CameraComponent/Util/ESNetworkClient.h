//
//  ESNetworkClient.h
//  CameraComponent
//
//  Created by SeaEagle on 15/2/11.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ESDebugLog.h"
#import "ESAppMacro.h"
#import "GTMBase64.h"
#import "AFNetworking.h"

@interface ESNetworkClient : NSObject{
    //
    NSURL *baseURL;
    //
    AFHTTPClient *httpClient;
}

// 成功回调
typedef void ( ^CurrencyJsonResponseSuccessBlock ) ( NSURLRequest *request , NSHTTPURLResponse *response , id JSON );
// 失败回调
typedef void ( ^CurrencyJsonResponseErrorBlock ) ( NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON );

- (ESNetworkClient *)initManager;

-(AFHTTPRequestOperation *)getJson:(NSDictionary *)token params:(NSDictionary *)params
                      onCompletion:(CurrencyJsonResponseSuccessBlock) successBlock
                           onError:(CurrencyJsonResponseErrorBlock) errorBlock;
@end
