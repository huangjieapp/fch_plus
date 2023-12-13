//
//  CGCEidtMessView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/21.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCEidtMessView.h"

@interface CGCEidtMessView()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, copy) CANELMBLOCK  canelMB;

@property (nonatomic, copy) SUREMBLOCK  sureMB;

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *desc;


@end

@implementation CGCEidtMessView


- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withDesStr:(NSString *)des withCanel:(CANELCLICK)canel withSure:(SUREMBLOCK)sure {

    
    if (self=[super initWithFrame:frame]) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"CGCEidtMessView" owner:self options:nil] lastObject];
        
        self.titleText.delegate=self;
        self.titleText.text=title;
        self.descTextView.delegate=self;
        self.descTextView.text=des;

        self.canelMB = canel;
        self.sureMB = sure;
        self.titleStr=title;
        self.desc=des;
        [self.bgBtn addTarget:self action:@selector(dismissClickView)];
        [self.canelBtn addTarget:self action:@selector(dismissClickView)];
        [self.sureBtn addTarget:self action:@selector(sureClick)];
    }

    return self;

}

- (void)dismissClickView{

    if (self.canelMB) {
        self.canelMB();
    }
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self removeFromSuperview];

}

- (void)sureClick{
    if (self.sureMB) {
        self.sureMB(self.titleStr, self.desc);
    }
    [self dismissClickView];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
  
    return YES;

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
 
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
   
    self.titleStr=textField.text;
   
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ([string isEqualToString:@"\n"]) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
    
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.topH.constant=80;
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.topH.constant=160;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    self.desc=textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
    
    return YES;

}


- (void)layoutSubviews{

    self.width=KScreenWidth;
    self.height=KScreenHeight;

}

@end
