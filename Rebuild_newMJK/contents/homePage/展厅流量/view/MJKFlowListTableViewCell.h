//
//  MJKFlowListTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/7.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKFlowListSecondSubModel.h"

@interface MJKFlowListTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *handImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepLabelLayout;
@property (weak, nonatomic) IBOutlet UILabel *sepLabel;
@property (weak, nonatomic) IBOutlet UILabel *proceTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handImageLayout;
@property (weak, nonatomic) IBOutlet UIButton *tickButton;
@property (nonatomic, assign) BOOL isAgain;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;

@property (nonatomic, strong) MJKFlowListSecondSubModel *model;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@end
