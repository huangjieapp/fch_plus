//
//  ServiceTaskDetailHeaderTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/30.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ServiceTaskDetailHeaderTableViewCell.h"

@implementation ServiceTaskDetailHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headLab.hidden=YES;
    self.headLab.text=nil;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}


- (IBAction)clickPhoneButton:(id)sender {
    if (self.clickTopThreeButtonBlock) {
        self.clickTopThreeButtonBlock(0);
    }
}

- (IBAction)clickMailButton:(id)sender {
    if (self.clickTopThreeButtonBlock) {
        self.clickTopThreeButtonBlock(1);
    }
}

- (IBAction)clickWechatButton:(id)sender {
    if (self.clickTopThreeButtonBlock) {
        self.clickTopThreeButtonBlock(2);
    }
}

@end
