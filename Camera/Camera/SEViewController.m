//
//  SEViewController.m
//  Camera
//
//  Created by SeaEagle on 15/1/8.
//  Copyright (c) 2015年 Eagle. All rights reserved.
//

#import "SEViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface SEViewController ()
<UIImagePickerControllerDelegate, UINavigationBarDelegate>

@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UIButton *takePictureButton;

@property(strong, nonatomic) MPMoviePlayerController *moviePlayerController;
@property(strong, nonatomic) UIImage *image;
@property(strong, nonatomic) NSURL *movieURL;
@property(copy, nonatomic) NSString *lastChosenMediaType;

@end

@implementation SEViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.takePictureButton.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateDisplay];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 相片展示或播放视频
- (void)updateDisplay{
    if([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage]){
        self.imageView.image = self.image;
        self.imageView.hidden = NO;
        self.moviePlayerController.view.hidden = YES;
    }else if([self.lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]){
        [self.moviePlayerController.view removeFromSuperview];
        self.moviePlayerController = [[MPMoviePlayerController alloc]initWithContentURL:self.movieURL];
        [self.moviePlayerController play];
        UIView *movieView = self.moviePlayerController.view;
        movieView.frame = self.imageView.frame;
        movieView.clipsToBounds = YES;
        [self.view addSubview:movieView];
        self.imageView.hidden = YES;
    }
}

- (void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0 ){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    }else{
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Error accessing media"
                            message:@"Unsupported media source"
                            delegate:nil
                            cancelButtonTitle:@"Drat"
                            otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - 相机delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType = info[UIImagePickerControllerMediaType];
    if([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage]){
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        self.image = [self shrinkImage:chosenImage toSize:self.imageView.bounds.size];
    }else if([self.lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]){
        self.movieURL = info[UIImagePickerControllerMediaURL];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 拍照
/*
 * 拍照
 */
- (IBAction)shootPictureOrVideo:(id)sender{
    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

/*
 * 选择照片
 */
- (IBAction)selectExistingPictureOrVideo:(id)sender{
    [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - 相片缩放
- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGFloat originalAspect = original.size.width / original.size.height;
    CGFloat targetAspect = size.width / size.height;
    CGRect targetRect;
    if(originalAspect > targetAspect){
        targetRect.size.width = size.width;
        targetRect.size.height = size.height * targetAspect / originalAspect;
        targetRect.origin.x = 0;
        targetRect.origin.y = (size.height - targetRect.size.height)*0.5;
    }else if(originalAspect < targetAspect){
        targetRect.size.width = size.width * originalAspect / targetAspect;
        targetRect.size.height = size.height;
        targetRect.origin.x = (size.width - targetRect.size.width)*0.5;
        targetRect.origin.y = 0;
    }else{
        targetRect = CGRectMake(0, 0, size.width, size.height);
    }
    [original drawInRect:targetRect];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return final;
}

@end
