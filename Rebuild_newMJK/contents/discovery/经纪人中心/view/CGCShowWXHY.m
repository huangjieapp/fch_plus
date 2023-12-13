//
//  CGCShowWXHY.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/7/19.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCShowWXHY.h"

@implementation CGCShowWXHY


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.bgBtn addTarget:self action:@selector(btnClick:)];
    [self.weixinBtn addTarget:self action:@selector(btnClick:)];
    [self.delBtn addTarget:self action:@selector(btnClick:)];
}

- (void)btnClick:(UIButton *)btn{
    if (self.wBlock) {
        self.wBlock(btn.titleNormal);
    }
    [self dismissView];
}

+(instancetype)getView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CGCShowWXHY class]) owner:self options:nil] lastObject];
    
}

- (void)dismissView{
     [self removeFromSuperview];
}

- (void)showView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.width=WIDE;
    self.height=HIGHT;
    
}

@end
