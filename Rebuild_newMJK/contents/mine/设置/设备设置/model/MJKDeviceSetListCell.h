//
//  MJKDeviceSetListCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/31.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKFlowInstrumentSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKDeviceSetListCell : UITableViewCell
/** MJKFlowInstrumentSubModel*/
@property (nonatomic, strong) MJKFlowInstrumentSubModel *model;
/** editButtonBlock*/
@property (nonatomic, copy) void(^editButtonActionBlock)(void);
/** deleteButtonBlock*/
@property (nonatomic, copy) void(^deleteButtonActionBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
