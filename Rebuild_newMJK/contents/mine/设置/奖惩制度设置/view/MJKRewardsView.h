//
//  MJKRewardsView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/30.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKCustomReturnSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKRewardsView : UIView
/** MJKCustomReturnSubModel*/
@property (nonatomic, strong) MJKCustomReturnSubModel *model;
/** 取消s时返回*/
@property (nonatomic, copy) void(^cancelViewBlock)(void);
/** 定额或随机红包*/
@property (nonatomic, copy) void(^fixedOrRandomBlock)(NSString *str);
/** 输入值改变*/
@property (nonatomic, copy) void(^changeValueBlock)(NSString *type, NSString *str);
/** 确定按钮*/
@property (nonatomic, copy) void(^sureButtonActionBlock)(void);
/** 隐藏目标数*/
@property (nonatomic, strong) NSString *hiddenStr;
@end

NS_ASSUME_NONNULL_END
