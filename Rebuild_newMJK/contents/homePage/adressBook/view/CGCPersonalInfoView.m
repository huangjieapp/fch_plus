//
//  CGCPersonalInfoView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCPersonalInfoView.h"

@implementation CGCPersonalInfoView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  
    self.headImg.layer.cornerRadius=40;
    self.headImg.layer.masksToBounds=YES;
    
    self.mesBtn.layer.cornerRadius=4;
    self.mesBtn.layer.borderWidth=0.5;
    self.mesBtn.layer.borderColor=DBColor(255, 255, 255).CGColor;
    self.mesBtn.layer.masksToBounds=YES;
    
    self.telBtn.layer.cornerRadius=4;
    self.telBtn.layer.borderWidth=0.5;
    self.telBtn.layer.borderColor=DBColor(255, 255, 255).CGColor;
    self.telBtn.layer.masksToBounds=YES;

  
}

- (instancetype)initWithFrame:(CGRect)frame withTel:(TELBLOCK)telBlock withMess:(MESSBLOCK)messBlock{


    if (self=[super initWithFrame:frame]) {
        
        self=[[[NSBundle mainBundle] loadNibNamed:@"CGCPersonalInfoView" owner:self options:nil] lastObject];
        self.telB = telBlock;
        self.messB = messBlock;
        [self.telBtn addTarget:self action:@selector(telClick)];
        [self.mesBtn addTarget:self action:@selector(messClick)];

        
    }

    return self;

}

- (void)telClick{

    if (self.telB) {
        self.telB();
    }
}

- (void)messClick{

    if (self.messB) {
        self.messB();
    }
}

@end
