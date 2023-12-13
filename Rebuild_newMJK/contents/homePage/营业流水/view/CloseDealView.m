//
//  CloseDealView.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/26.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "CloseDealView.h"

@interface CloseDealView()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@end
@implementation CloseDealView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapDismissView:)];
    tap.delegate=self;
    [self addGestureRecognizer:tap];
    
    
    _firstTextField.delegate=self;
    _firstTextField.keyboardType=UIKeyboardTypeDecimalPad;
    _secondTextField.delegate=self;
    _secondTextField.keyboardType=UIKeyboardTypeNumberPad;
    _thirdTextField.delegate=self;
    _fourthTextF.delegate=self;
    _fourthTextF.userInteractionEnabled=NO;
    
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark --click
- (IBAction)clickCancel:(id)sender {
    if (self.clickCancelBlock) {
        self.clickCancelBlock();
    }
    
     [self dismissView];
}

- (IBAction)clickSure:(id)sender {
    if (self.clickSureBlock) {
        self.clickSureBlock(self.firstTextField.text, self.secondTextField.text, self.thirdTextField.text,self.fourthTextF.text);
    }
    
    [self dismissView];
}

-(void)TapDismissView:(UITapGestureRecognizer*)tap{
    [self clickCancel:nil];
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


#pragma mark  --funcation
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[DBTools findFirstResponderBeneathView:self] resignFirstResponder];
    
}


-(void)keyBoardWillHidden:(NSNotification*)notif{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.frame;
        
        frame.origin.y = 0.0;
        
        self.frame = frame;
        
    }];
    
}

//开始编辑时 视图上移 如果输入框不被键盘遮挡则不上移。

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[textField convertRect:textField.bounds toView:self];
    
    CGFloat aa = KScreenHeight - (rect.origin.y + rect.size.height + 216 +50+30+50+70);
    //    +self.view.frame.origin.y
    CGFloat rects=aa;
    
    NSLog(@"aa%f",rects);
    
    if (rects <= 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = self.frame;
            //frame.origin.y+
            frame.origin.y = rects;
            
            self.frame = frame;
            
        }];
        
    }
    
    return YES;
    
}


@end
