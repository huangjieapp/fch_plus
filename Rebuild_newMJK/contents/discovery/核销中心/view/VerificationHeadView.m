//
//  VerificationHeadView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "VerificationHeadView.h"

@implementation VerificationHeadView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
     [self.telBtn addTarget:self action:@selector(btnClick:)];
     [self.messBtn addTarget:self action:@selector(btnClick:)];
     [self.wxBtn addTarget:self action:@selector(btnClick:)];
    
    
}

- (void)btnClick:(UIButton *)btn{
    
    if (self.verBlock) {
        self.verBlock(btn.titleNormal);
    }
}

-(void)layoutSubviews{
    
    self.width=WIDE;
    self.height=160;
    
}

+(instancetype)getView{
    
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([VerificationHeadView class]) owner:self options:nil] lastObject];
}
@end
