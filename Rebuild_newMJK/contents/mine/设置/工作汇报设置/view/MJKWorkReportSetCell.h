//
//  MJKWorkReportSetCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/9.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKDataDicModel.h"
#import "MJKCustomReturnSubModel.h"
@class MJKPushDefaultListModel;

@interface MJKWorkReportSetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** model*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeftLayout;
@property (nonatomic, strong) MJKDataDicModel *model;
/** sea model*/
@property (nonatomic, strong) MJKCustomReturnSubModel *seaModel;
/** safe model*/
@property (nonatomic, strong) MJKCustomReturnSubModel *safeModel;

/** MJKPushDefaultListModel*/
@property (nonatomic, strong) MJKPushDefaultListModel *defaultModel;

/** remindModel*/
@property (nonatomic, strong) MJKCustomReturnSubModel *remindModel;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitchButton;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** switch open*/
@property (nonatomic, copy) void(^openSwitchBlock)(BOOL isOn);
@property (nonatomic, copy) void(^selectButtonBlock)(void);
@end
