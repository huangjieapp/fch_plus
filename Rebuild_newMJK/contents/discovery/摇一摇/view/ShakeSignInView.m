//
//  ShakeSignInView.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/6.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ShakeSignInView.h"

@interface ShakeSignInView()

@property (weak, nonatomic) IBOutlet UIButton *SignInButton;

@end

@implementation ShakeSignInView

//  145高
+(instancetype)creatShakeSignInView{
    ShakeSignInView*shakeView=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ShakeSignInView class]) owner:nil options:nil].firstObject;
    shakeView.frame=CGRectMake(0, 0, KScreenWidth, 145);
    
//    [shakeView.inputTextField addTarget:self action:@selector(ChangeTextField:) forControlEvents:UIControlEventValueChanged];
    
    
    return shakeView;
}
- (IBAction)clickSignButton:(id)sender {
    if (self.clickCompleteBlock) {
        self.clickCompleteBlock(self.inputTextField.text);
    }
    
    
}


//-(void)ChangeTextField:(UITextField*)textField{
//    
//    
//}


@end
