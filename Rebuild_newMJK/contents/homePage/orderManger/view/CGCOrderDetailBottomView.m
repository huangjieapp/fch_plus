//
//  CGCOrderDetailBottomView.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CGCOrderDetailBottomView.h"

@implementation CGCOrderDetailBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews{

    self.width=KScreenWidth;
    self.height=50;
    self.totalpricesLab.centerY=self.centerY;

}
@end
