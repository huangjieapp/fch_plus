//
//  MJKScratchableLatexPhotoView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKMaterialPhotoView : UIView
/** vc*/
@property (nonatomic, strong) UIViewController *rootVC;
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger imageCount;
/** 有图片*/
@property (nonatomic, strong) NSArray *imageURLArray;
/** 多选照片*/
@property (nonatomic, assign) BOOL isChooseMorePhotos;
/** 返回上传的url*/
@property (nonatomic, copy) void(^backUrlArray)(NSArray *arr, CGFloat height);
@property (nonatomic, copy) void(^backUrlDataBlock)(NSData *data);
/** <#备注#>*/
@property (nonatomic, copy) void(^backDelDataBlock)(NSInteger delTag);
@end

NS_ASSUME_NONNULL_END
