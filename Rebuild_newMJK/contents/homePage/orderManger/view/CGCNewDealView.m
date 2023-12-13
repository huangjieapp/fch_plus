//
//  CGCNewDealView.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/23.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CGCNewDealView.h"

@implementation CGCNewDealView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.scanBgView.layer.cornerRadius=5.0;
    self.scanBgView.layer.masksToBounds=YES;
    self.scanBgView.layer.borderWidth=0.5;
    self.scanBgView.layer.borderColor=CGCWEiXINColor.CGColor;

    // Drawing code
}



- (void)layoutSubviews{

    self.width=KScreenWidth;
    self.height=KScreenHeight-64;
    
}

@end
