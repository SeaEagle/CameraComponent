//
//  ESSnapshootRecordItem.m
//  CameraComponent
//
//  Created by SeaEagle on 15/3/5.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESSnapshootRecordItem.h"

@implementation ESSnapshootRecordItem

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - 根据数据刷新显示的内容
//
- (void)updateDisplayContent:(ESSnapshootRecord *)snapshootRecord{
    _snapshootThemeTitle.text = snapshootRecord.title;//主题
    _snapshootTime.text = snapshootRecord.uploadTime;//上传时间
    _snapshootDescription.text = snapshootRecord.remark;//备注
    _snapshootLocation.text = snapshootRecord.address;//地址
    [self updateImagesData:snapshootRecord.photos];
}

// 更新图片数据
- (void)updateImagesData:(NSArray *)images{
    if(nil==smallImages){
        smallImages = [[NSMutableArray alloc]init];
        bigImages = [[NSMutableArray alloc]init];
    }else{
        [smallImages removeAllObjects];
        [bigImages removeAllObjects];
    }
    for (NSDictionary *data in images) {
        // data对应的key有:
        // picType: 图片类型
        // picLocation: 小图
        // bigPicLocation: 大图
        [smallImages addObject: [data objectForKey:@"picLocation"]];
        [bigImages addObject: [data objectForKey:@"bigPicLocation"]];
    }
    // 更新图片显示
    [self updateImagesDisplay];
}

// 更新图片显示
- (void)updateImagesDisplay{
    // 设置图片显示大小
    if( 0 == imageWidth && 0 == imageHeight ){
        CGFloat currentScreenWidth = [[UIScreen mainScreen]bounds].size.width;
        //
        standScreenWidth = 375;
        standImageGap = 12;
        standImageWidth = 57;
        standImageHeight = 71;
        //
        imageGap = currentScreenWidth * standImageGap / standScreenWidth;
        imageWidth = (currentScreenWidth - 6 * imageGap) / 5;
        imageHeight = imageWidth * standImageHeight / standImageWidth;
        
    }
    for ( int i=0; i<[smallImages count]; i++ ) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(imageGap+(imageGap+imageWidth)*i, imageGap, imageWidth, imageHeight)];
        view.backgroundColor = [UIColor redColor];
        [_snapshootImages addSubview:view];
    }
}

@end
