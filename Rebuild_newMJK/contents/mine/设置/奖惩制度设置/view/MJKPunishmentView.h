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

@interface MJKPunishmentView : UIView
/** MJKCustomReturnSubModel*/
@property (nonatomic, strong) MJKCustomReturnSubModel *model;
/** 取消s时返回*/
@property (nonatomic, copy) void(^cancelViewBlock)(void);
/** 输入值改变*/
@property (nonatomic, copy) void(^changeValueBlock)(NSString *str);
/** 确定按钮*/
@property (nonatomic, copy) void(^sureButtonActionBlock)(void);
@end

NS_ASSUME_NONNULL_END
