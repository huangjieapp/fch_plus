//
//  BusinessDayTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/25.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "BusinessDayTableViewCell.h"

@implementation BusinessDayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

@end
