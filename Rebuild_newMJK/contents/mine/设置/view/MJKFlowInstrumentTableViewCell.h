//
//  MJKFlowInstrumentTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKFlowInstrumentSubModel.h"

@interface MJKFlowInstrumentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *manageLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UIButton *liveButton;
@property (nonatomic, strong) MJKFlowInstrumentSubModel *model;

@property (nonatomic, copy) void(^clickEditButtonBlock)(void);
@property (nonatomic, copy) void(^clickDeleteButtonBlock)(void);
@property (nonatomic, copy) void(^clickLiveButtonBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
