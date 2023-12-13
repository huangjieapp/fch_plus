//
//  CGCHelpView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCHelpView.h"

@interface CGCHelpView()

@property (nonatomic, copy) PICBLOCK picBlock;

@property (nonatomic, copy) SENDBLOCK sendBlock;

@end

@implementation CGCHelpView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self setBtnLayer:self.btn1];
    [self setBtnLayer:self.btn2];
    [self setBtnLayer:self.btn3];
}

- (void)setBtnLayer:(UIButton *)btn{
    btn.layer.borderWidth=0.5;
    btn.layer.borderColor=DBColor(0, 0, 0).CGColor;
    btn.layer.cornerRadius=4.0;
    btn.layer.masksToBounds=YES;
}

-(instancetype)initWithFrame:(CGRect)frame withPicB:(PICBLOCK)picB withSendB:(SENDBLOCK)sendB{

    if (self=[super initWithFrame:frame]) {
        self=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        self.btn1.tag=111;
        self.btn2.tag=222;
        self.btn3.tag=333;
        self.picBlock = picB;
        self.sendBlock = sendB;
        
        [self.btn1 addTarget:self action:@selector(btnClick:)];
        [self.btn2 addTarget:self action:@selector(btnClick:)];
        [self.btn3 addTarget:self action:@selector(btnClick:)];
        [self.disSend addTarget:self action:@selector(sendClick:)];
        [self.sendBtn addTarget:self action:@selector(sendClick:)];
        [self.helpBtn addTarget:self action:@selector(sendClick:)];
        
    }

    return self;
}

- (void)layoutSubviews{
    self.y=64;
    self.width=KScreenWidth;
    self.height=KScreenHeight-64;

}

- (void)btnClick:(UIButton *)btn{

    if (btn.tag==111) {
        if (self.picBlock) {
            self.picBlock(self.lab1, self.btn1, self.desLab);
        }
    }
    if (btn.tag==222) {
        if (self.picBlock) {
          self.picBlock(self.lab2, self.btn2, self.desLab);
        }
    }
    if (btn.tag==333) {
        if (self.picBlock) {
           self.picBlock(self.lab3, self.btn3, self.desLab);
        }
    }
    

}

- (void)sendClick:(UIButton *)btn{
    if ([btn.titleNormal isEqualToString:@"不发送提醒"]) {
        if (self.sendBlock) {
            self.sendBlock(self.disSend);
        }
    }
    if ([btn.titleNormal isEqualToString:@"发送提醒"]) {
        if (self.sendBlock) {
            self.sendBlock(self.sendBtn);
        }
    }
    if ([btn.titleNormal isEqualToString:@"开始协助"]) {
        if (self.sendBlock) {
            self.sendBlock(self.helpBtn);
        }
    }
    
}


@end
