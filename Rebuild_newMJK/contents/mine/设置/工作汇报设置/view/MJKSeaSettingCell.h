//
//  MJKSeaSettingCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKCustomReturnSubModel.h"
#import "MJKDataDicModel.h"

@interface MJKSeaSettingCell : UITableViewCell
/** root vc*/
@property (nonatomic, weak) UIViewController *rootVC;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (nonatomic, copy) void(^backButtonActionBlock)(MJKCustomReturnSubModel *model);
@property (nonatomic, copy) void(^textChangeBlock)(MJKCustomReturnSubModel *model);
/** sea model*/
@property (nonatomic, strong) MJKCustomReturnSubModel *seaModel;
/** safe model*/
@property (nonatomic, strong) MJKCustomReturnSubModel *safeModel;
/** work model*/
@property (nonatomic, strong) MJKDataDicModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
