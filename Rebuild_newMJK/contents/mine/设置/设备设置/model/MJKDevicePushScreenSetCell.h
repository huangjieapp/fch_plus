//
//  MJKDevicePushScreenSetCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/7.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKFlowInstrumentSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKDevicePushScreenSetCell : UITableViewCell
/** MJKFlowInstrumentSubModel*/
@property (nonatomic, strong) MJKFlowInstrumentSubModel *model;
/** select back*/
@property (nonatomic, copy) void(^selectBackBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
