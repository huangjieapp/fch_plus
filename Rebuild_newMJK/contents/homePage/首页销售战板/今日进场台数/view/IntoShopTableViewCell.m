//
//  IntoShopTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/14.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "IntoShopTableViewCell.h"


@interface IntoShopTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation IntoShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
