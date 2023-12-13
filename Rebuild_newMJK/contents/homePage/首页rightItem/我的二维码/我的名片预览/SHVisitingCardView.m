//
//  SHVisitingCardView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/10.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHVisitingCardView.h"
#import "SAMTextView.h"

@interface SHVisitingCardView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *topPartView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet SAMTextView *subTextView;




@end


@implementation SHVisitingCardView


+(instancetype)visitingCardView{
    SHVisitingCardView*cardView= [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    cardView.frame=CGRectMake(0, 64, KScreenWidth, KScreenHeight-64);
    return cardView;

    
}



-(void)awakeFromNib{
    [super awakeFromNib];
    self.hidden=YES;
    self.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.3];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDismiss)];
    tap.delegate=self;
    [self addGestureRecognizer:tap];

    
    self.mainView.backgroundColor=[UIColor whiteColor];
    self.mainView.layer.cornerRadius=6;
    self.mainView.layer.masksToBounds=YES;
    
    self.topPartView.backgroundColor=[UIColor whiteColor];
    self.topPartView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.topPartView.layer.borderWidth=1;
    
    self.subTextView.placeholder=@"请输入详情";
    
    
}


-(void)show{
    self.hidden=NO;
}
-(void)hidden{
    self.hidden=YES;
}


#pragma mark -- delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.mainView]) {
        return NO;
    }
    
    return YES;
}


#pragma mark  --touch

-(void)clickDismiss{
    [[self findFirstResponderBeneathView:self] resignFirstResponder];
    [self hidden];
   
}


- (IBAction)clickImageButton:(id)sender {
    if (self.ClickImageButtonBlock) {
        self.ClickImageButtonBlock();
    }
    
}


- (IBAction)clickCancel:(id)sender {
}

- (IBAction)clickChange:(id)sender {
}



#pragma mark  隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self] resignFirstResponder];
}


- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}


@end
