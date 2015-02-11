//
//  ESNetworkClient.m
//  CameraComponent
//
//  Created by SeaEagle on 15/2/11.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESNetworkClient.h"

@implementation ESNetworkClient

- (ESNetworkClient *)initManager{
    // 基地址
    baseURL = [NSURL URLWithString:SERVER_URL];
    // 
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    return self;
}

// 表单数据提交
- (AFHTTPRequestOperation *)getJson:(NSDictionary *)token params:(NSDictionary *)params
                      onCompletion:(CurrencyJsonResponseSuccessBlock) successBlock
                           onError:(CurrencyJsonResponseErrorBlock) errorBlock{
    
    // 将参数及数据转成json格式并且base64编码
    NSData *data =[NSJSONSerialization dataWithJSONObject:params
                                                  options:NSJSONWritingPrettyPrinted
                                                    error:nil];
    NSString *pstring = [[NSString alloc] initWithData:[GTMBase64 encodeData:data]  encoding:NSUTF8StringEncoding];
    NSMutableDictionary *paramsTarget = [[NSMutableDictionary alloc] initWithDictionary:@{@"p":pstring}];
    
    ESWQINFO(@"url：%@p=%@",SERVER_URL,pstring);
    
    // 设置HTTP头部参数, token表示码表
    [httpClient setDefaultHeader:@"x-action-type" value:[token objectForKey:@"x-action-type"]];
    [httpClient setDefaultHeader:@"x-session-id" value:[token objectForKey:@"x-session-id"]];
    // 创建请求
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"" parameters:paramsTarget];
    // 根据请求创建操作
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                             // 成功返回数据
                                             
                                             NSLog(@"Status Code: %ld", response.statusCode );
                                             NSLog(@"Result: %@", JSON);
                                             successBlock(request, response, JSON);
                                             
                                         }failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
                                             // 失败处理
                                             
                                             NSLog(@"Error: %@", error);
                                             NSLog(@"Status Code: %ld", response.statusCode );
                                             NSLog(@"Result: %@",JSON);
                                             errorBlock(request, response, errorBlock, JSON);
                                             
                                         }];
    // 开始执行请求操作
    [operation start];
    
    return operation;
}

@end
