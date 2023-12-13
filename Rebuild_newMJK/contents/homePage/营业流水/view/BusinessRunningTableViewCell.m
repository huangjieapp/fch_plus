//
//  BusinessRunningTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/25.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "BusinessRunningTableViewCell.h"

@implementation BusinessRunningTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor=[UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    // Configure the view for the selected state
}

@end
