//
//  CouponTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/11.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CouponTableViewCell.h"

@interface CouponTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *enoughLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;

@end

@implementation CouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.contentView.backgroundColor=DBColor(239, 239, 244);
    [self.isSelectedButton setBackgroundImage:[UIImage imageNamed:@"未打钩"] forState:UIControlStateNormal];
    [self.isSelectedButton setBackgroundImage:[UIImage imageNamed:@"打钩"] forState:UIControlStateSelected];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=0;
    
    // Configure the view for the selected state
}

@end
