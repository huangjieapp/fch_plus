//
//  MJKUploadMemoView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKUploadMemoView : UIView
- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andSendMassage:(BOOL)isSend andRootVC:(UIViewController *)rootVC;
@property (nonatomic, copy) void(^messageButtonBloack)(UIButton *sender);
@property (nonatomic, copy) void(^commitButtonBloack)(NSArray *imageArr, NSString *remarkText);
@property (nonatomic, strong) NSString *c_id;//轨迹id
@property (nonatomic, strong) NSArray *imageUrlArr;//详情图片arr
@property (nonatomic, strong) NSString *remark;//备注
@property (nonatomic, weak) UIViewController *rootVC;
@end
