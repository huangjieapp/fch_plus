                                //
//  CGCIntegrateHView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/6/1.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCIntegrateHView.h"

@implementation CGCIntegrateHView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.headImg.layer.cornerRadius=30;
    self.headImg.layer.masksToBounds=YES;
}


+(instancetype)getView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CGCIntegrateHView class]) owner:self options:nil] lastObject];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.width=WIDE;
    self.height=200;
    
}

@end
