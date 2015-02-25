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
    //
    
    return self;
}

// 表单数据提交
- (AFHTTPRequestOperation *)getJson:(NSDictionary *)token params:(NSDictionary *)params
                      onCompletion:(CurrencyJsonResponseSuccessBlock) successBlock
                           onError:(CurrencyJsonResponseErrorBlock) errorBlock{
    
    // 将数据转成json格式并且base64编码
    NSData *data =[NSJSONSerialization dataWithJSONObject:params
                                                  options:NSJSONWritingPrettyPrinted
                                                    error:nil];
    NSString *pstring = [[NSString alloc] initWithData:[GTMBase64 encodeData:data]  encoding:NSUTF8StringEncoding];
    NSMutableDictionary *paramsTarget = [[NSMutableDictionary alloc] initWithDictionary:@{@"p":pstring}];
    
    // 设置HTTP头部参数, token存放头参数对应的数据
    for (NSString *key in [token allKeys]) {
        [httpClient setDefaultHeader:key value:[token objectForKey:key]];
    }
    // 创建GET请求
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"" parameters:paramsTarget];
    
    // 根据请求创建操作
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                             // 成功返回数据
                                             NSLog(@"Request: %@", request.URL);// 请求的URL链接
                                             NSLog(@"Status Code: %ld", response.statusCode );// 返回的状态码
                                             NSLog(@"Result: %@", JSON);// 返回的JSON数据
                                             successBlock(request, response, JSON);//
                                         }failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
                                             // 失败处理
                                             NSLog(@"Error: %@", error);// 发生的错误
                                             NSLog(@"Status Code: %ld", response.statusCode );// 返回的状态码
                                             NSLog(@"Result: %@",JSON);// 返回的JSON数据
                                             errorBlock(request, response, errorBlock, JSON);//
                                         }];
    // 开始执行请求操作
    [operation start];
    
    return operation;
}

// 文件数据提交 - 暂定为处理图片文件
-(AFHTTPRequestOperation *)uploadFile:(NSDictionary *)token params:(NSDictionary *)params
                         onCompletion:(CurrencyJsonResponseSuccessBlock) successBlock
                              onError:(CurrencyJsonResponseErrorBlock) errorBlock{
    // 初始化
    if ( nil == fileURL ) {
        fileURL = [NSURL URLWithString:FILE_URL];
        fileHttpClient = [[AFHTTPClient alloc]initWithBaseURL:fileURL];
    }
    
    // http head配置
    //
    [fileHttpClient setDefaultHeader:@"x-action-type" value:[token objectForKey:@"x-action-type"]];
    //
    [fileHttpClient setDefaultHeader:@"x-session-id" value:[token objectForKey:@"x-session-id"]];
    // 指定文件类型
    [fileHttpClient setDefaultHeader:@"x-type" value:[token objectForKey:@"x-type"]];
    // 设定ticket
    [fileHttpClient setDefaultHeader:@"x-ticket" value:[token objectForKey:@"x-ticket"]];
    
    UIImage *image = [params objectForKey:@"image"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0);
    
    NSMutableURLRequest *request = [fileHttpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"cameara" fileName:@"cameara.jpg" mimeType:@"image/jpeg"];
    }];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%ld", response.statusCode );
        NSLog(@"Upload Success: %@", JSON);
        
    } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        
        NSLog(@"Error: %@", error);
        NSLog(@"status: %ld", response.statusCode );
        NSLog(@"Failure %@",JSON);
        
    }];
    //
    [operation start];
    //
    return operation;
}

@end
