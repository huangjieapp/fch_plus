//
//  AddBrokerView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/15.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "AddBrokerView.h"

@interface AddBrokerView ()<UITextFieldDelegate>

@end

@implementation AddBrokerView

- (void)drawRect:(CGRect)rect{
    
    
    [super drawRect:rect];
    self.bgView.layer.cornerRadius=4;
    self.bgView.layer.masksToBounds=YES;
    self.nameText.delegate=self;
    self.nameText.tag=111;
    self.telText.delegate=self;
    self.telText.tag=222;
    [self.canelBtn addTarget:self action:@selector(btnClick:)];
    [self.sureBtn addTarget:self action:@selector(btnClick:)];
    [self.bgBtn addTarget:self action:@selector(removeView)];
    
}

- (void)layoutSubviews{
    
    self.width=WIDE;
    self.height=HIGHT;
}

- (void)removeView{
    
    [self removeFromSuperview];
}

- (void)showView{

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

- (void)btnClick:(UIButton *)btn{
    
    if (self.broBlock) {
        self.broBlock(btn.titleLabel.text, @"");
    }
}

+(instancetype)getView{
    
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AddBrokerView class]) owner:self options:nil] lastObject];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==111) {
        if (self.broBlock) {
            self.broBlock(@"姓名", textField.text);
        }
    }
    if (textField.tag==222) {
        if (self.broBlock) {
            self.broBlock(@"电话", textField.text);
        }
    }
    
}
@end
