//
//  ESMainView.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/21.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESMainView.h"

@implementation ESMainView

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    if (self) {
        CGRect frame = [[UIScreen mainScreen]applicationFrame];
        frame.origin.y = 0;
        //声明拍照组件
        cameraComponent = [[ESCameraComponent alloc]initWithFrame:frame];
        //指定获取相片的方式, 是否限制拍照数量, 拍照数量最大值
        [cameraComponent configureComponentWithType:ESPhotoLibraryOrCamera maxLimitMark:YES maxCount:5];
        //添加到view
        [self addSubview:cameraComponent];
        
        UIButton *uploadButoon = [UIButton buttonWithType:UIButtonTypeSystem];
        uploadButoon.frame = CGRectMake(0, cameraComponent.frame.origin.y+cameraComponent.frame.size.height+cameraComponent.frame.size.height*0.3, frame.size.width, frame.size.height*0.1);
        [uploadButoon setTitle:@"上传文件" forState:UIControlStateNormal];
        uploadButoon.backgroundColor = [UIColor yellowColor];
        [uploadButoon addTarget:self action:@selector(uploadFile) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:uploadButoon];
    }
    return(self);
}

- (void)uploadFile{
    NSLog(@"BEGIN: UPLOAD……");
    
    NSURL *url = [NSURL URLWithString:@"http://10.19.160.65:8090"];
//    NSURL *url = [NSURL URLWithString:@"http://14.31.15.122:8080"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setDefaultHeader:@"x-type" value:@"png"];
    [httpClient setDefaultHeader:@"x-ticket" value:@"abcdefg123456789"];
    
    NSArray *imageArray = [cameraComponent getImageData];
    
    NSData *imageData = UIImageJPEGRepresentation((UIImage *)[imageArray objectAtIndex:0], 0);
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"camera" fileName:@"camera.jpg" mimeType:@"image/jpeg"];
    }];
    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//    }];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%ld", response.statusCode );
        NSLog(@"App.net Global Stream: %@", JSON);
        
    } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        
        NSLog(@"Error: %@", error);
        NSLog(@"status: %ld", response.statusCode );
        NSLog(@"Failure %@",JSON);
        
    }];
    [operation start];
    
//    [httpClient enqueueHTTPRequestOperation:operation];
}

@end
