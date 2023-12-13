//
//  BusinessDayHeaderCellView.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/25.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "BusinessDayHeaderCellView.h"

@implementation BusinessDayHeaderCellView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)clickCloseBill:(UIButton*)sender {
    if (self.closeBillBlock) {
        self.closeBillBlock();
    }
    
    sender.userInteractionEnabled=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled=YES;
    });
    
    
}

@end
