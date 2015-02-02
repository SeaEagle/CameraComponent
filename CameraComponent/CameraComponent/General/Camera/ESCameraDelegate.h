//
//  ESCameraDelegate.h
//  CameraComponent
//
//  Created by ElogisticsBase on 15/1/31.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#ifndef CameraComponent_ESCameraDelegate_h
#define CameraComponent_ESCameraDelegate_h

//本地照片代理
@protocol ESPickMultiPicDelegate <NSObject>
@required
//传递已选择的图片数据
- (void)transferMultiPic:(NSMutableDictionary *)dataDictionary;
@end

//图片预览代理
@protocol ESScanAndPickCommunicateDelegate <NSObject>
@required
- (void)selectOrNotOperationDelegate:(NSInteger)index currentSelectedCount:(int)count;
@end

#endif
