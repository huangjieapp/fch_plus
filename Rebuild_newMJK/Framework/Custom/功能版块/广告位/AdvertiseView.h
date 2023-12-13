//
//  AdvertiseView.h
//  zhibo
//
//  Created by 周焕强 on 16/5/17.
//  Copyright © 2016年 zhq. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
#define kUserDefaults [NSUserDefaults standardUserDefaults]

UIKIT_EXTERN NSString*const adImageName;
UIKIT_EXTERN NSString*const adUrl;

//static NSString *const adImageName = @"adImageName";
//static NSString *const adUrl = @"adUrl";
@interface AdvertiseView : UIView

/** 显示广告页面方法*/
- (void)show;
//点击图片
@property(nonatomic,copy)void(^clickAdvertImageBlock)(NSString*str);


/** 图片路径*/
@property (nonatomic, copy) NSString *filePath;



@end
