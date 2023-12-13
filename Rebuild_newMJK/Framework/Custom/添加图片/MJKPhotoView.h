//
//  MJKPhotoView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/26.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKPhotoView : UIView
/** vc*/
@property (nonatomic, strong) UIViewController *rootVC;
/** 是否编辑*/
@property (nonatomic, assign) BOOL isEdit;
/** 只有拍照*/
@property (nonatomic, assign) BOOL isCamera;
/** 有图片*/
@property (nonatomic, strong) NSArray *imageURLArray;
/** 返回上传的url*/
@property (nonatomic, copy) void(^backUrlArray)(NSArray *arr, NSArray *saveArr);
@property (nonatomic, copy) void(^backSaveUrlArray)(NSArray *arr);
/** title naem*/
@property (nonatomic, strong) NSString *titleNameStr;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger imageCount;

/** 返回dataz数据类型*/
@property (nonatomic, assign) BOOL backDataImage;
/** <#注释#>*/
@property (nonatomic, strong) NSString *mustStr;
@end
