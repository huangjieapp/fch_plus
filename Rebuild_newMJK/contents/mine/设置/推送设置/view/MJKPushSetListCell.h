//
//  MJKPushSetListCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/16.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKCustomReturnSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKPushSetListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *openSwitchButton;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger selectedSegmentIndex;
/** is edit*/
@property (nonatomic, assign) BOOL isEdit;
/** MJKCustomReturnSubModel*/
@property (nonatomic, strong) MJKCustomReturnSubModel *model;
@property (nonatomic, strong) MJKCustomReturnSubModel *rpModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 开启/关闭*/
@property (nonatomic, copy) void(^openButtonBlock)(BOOL isOpen);
/** 修改*/
@property (nonatomic, copy) void(^editButtonBlock)(void);
//openSwitchBlock
@property (nonatomic, copy) void(^openSwitchBlock)(BOOL isOn);
@end

NS_ASSUME_NONNULL_END
