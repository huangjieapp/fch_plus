//
//  MJKScratchableLatexPhotoView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKScratchableLatexPhotoView : UIView
/** vc*/
@property (nonatomic, strong) UIViewController *rootVC;
/** 有图片*/
@property (nonatomic, strong) NSArray *imageURLArray;
/** 返回上传的url*/
@property (nonatomic, copy) void(^backUrlArray)(NSArray *arr, CGFloat height);
@end

NS_ASSUME_NONNULL_END
