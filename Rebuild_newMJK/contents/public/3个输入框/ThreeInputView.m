//
//  ThreeInputView.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/1.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ThreeInputView.h"

@interface ThreeInputView()<UIGestureRecognizerDelegate>

@end

@implementation ThreeInputView

+(instancetype)showThreeInputViewAndSuccess:(clickSureBlock)sureBlock andCancel:(clickCancelBlock)cancelBlock{
    ThreeInputView*thisView=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    thisView.frame=[UIScreen mainScreen].bounds;
    thisView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
                             
    
    thisView.sureBlock=sureBlock;
    thisView.cancelBlock=cancelBlock;
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:thisView action:@selector(dismissView)];
    tap.delegate=thisView;
    [thisView addGestureRecognizer:tap];
    
    thisView.firstTextF.keyboardType=UIKeyboardTypeDefault;
    thisView.secondTextF.keyboardType=UIKeyboardTypeDecimalPad;
    thisView.thirdTextF.keyboardType=UIKeyboardTypeNumberPad;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:thisView selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:thisView selector:@selector(keyBoardHIdden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    return thisView;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)keyBoardShow:(NSNotification*)noti{
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.frame;
        
        frame.origin.y =-80;
        
        self.frame = frame;
        
    }];

    
}

-(void)keyBoardHIdden:(NSNotification*)noti{
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.frame;
        
        frame.origin.y = 0.0;
        
        self.frame = frame;
        
    }];

    
}


- (IBAction)clickCancel:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
     [self dismissView];
    
}
- (IBAction)clickSure:(id)sender {
    if (self.canCommitNoAll) {
        //不检测
        
    }else{
    
    if (self.firstTextF.text.length<1||self.secondTextF.text.length<1||self.thirdTextF.text.length<1) {
        [JRToast showWithText:@"必须填写全部三个内容才能提交"];
        return;
    }
        
    }
    
    if (self.sureBlock) {
        self.sureBlock(self.firstTextF.text, self.secondTextF.text, self.thirdTextF.text);
    }
    [self dismissView];
    
}


-(void)dismissView{
    [self removeFromSuperview];
}


#pragma mark  --delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.mainView]) {
        return NO;
    }
    return YES;
    
}


@end
