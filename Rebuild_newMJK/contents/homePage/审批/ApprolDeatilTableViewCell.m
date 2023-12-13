//
//  ApprolDeatilTableViewCell.m
//  mcr_s
//
//  Created by bipyun on 16/6/12.
//  Copyright © 2016年 match. All rights reserved.
//

#import "ApprolDeatilTableViewCell.h"

@implementation ApprolDeatilTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bavkeview.layer.cornerRadius=10.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
