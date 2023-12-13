//
//  MJKPushOpenSetSection0Cell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKCustomReturnSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKPushOpenMessageCell : UITableViewCell
/** MJKCustomReturnSubModel*/
@property (nonatomic, strong) MJKCustomReturnSubModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** select button block*/
@property (nonatomic, copy) void(^selectButtonBlock)(BOOL isSelected);
//openSwitchBlock
@property (nonatomic, copy) void(^openSwitchBlock)(BOOL isOn);
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
