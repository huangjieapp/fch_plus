//
//  CGCOrderDetailOtherCell.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCOrderDetailModel;

@interface CGCOrderDetailOtherCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *remarkLab;

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;

@property (weak, nonatomic) IBOutlet UIView *payView;

@property (weak, nonatomic) IBOutlet UIView *paytitleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHigh;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payHigh;


+ (instancetype)cellWithTableView:(UITableView *)tableView ;
- (void)reloadCellWith:(CGCOrderDetailModel *)model;

@end
