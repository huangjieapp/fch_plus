//
//  SHChatBarView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/1.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHChatBarView.h"

@implementation SHChatBarView

-(instancetype)init{
    NSArray*array=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    return [array firstObject];
    
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.borderColor=[UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0f].CGColor;
    self.layer.borderWidth=1;
    self.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];

    self.textView.layer.borderColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0f].CGColor;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.cornerRadius = 4.0f;
    self.textView.textContainerInset=UIEdgeInsetsMake(4, 4, 4, 4);
    
    
//    self.voiceRecordButton.layer.borderColor=[UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0f].CGColor;
//    self.voiceRecordButton.layer.borderWidth = 1.0f;
//    self.voiceRecordButton.layer.cornerRadius = 4.0f;
//    self.voiceRecordButton.backgroundColor=[UIColor whiteColor];

    
    self.textView.hidden=NO;
    self.faceButton.selected = self.otherButton.selected = self.voiceButton.selected = NO;
    [self.faceButton setImage:nil forState:UIControlStateNormal];
    [self.faceButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.faceButton setTitleColor:[UIColor blackColor]];
    
    
    self.voiceRecordButton.hidden = YES;
    self.voiceRecordButton.layer.cornerRadius = 4.0f;
    self.voiceRecordButton.layer.borderWidth = 1.0f;
    self.voiceRecordButton.layer.borderColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0f].CGColor;
    UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ClickLongPress:)];
//    longPress.minimumPressDuration=10.0;
    [self.voiceRecordButton addGestureRecognizer:longPress];
    
    
    

    
    //设置textView 固定行高
    YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
    mod.fixedLineHeight = 20.f;
    self.textView.linePositionModifier = mod;

    self.textView.font = [UIFont systemFontOfSize:16.f];
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;

    
    
}


- (IBAction)handleButtonAction:(UIButton *)aButton {
    
    MyLog(@"touch");
    
    if (aButton==self.voiceButton) {
        if (!self.voiceButton.selected) {
            
            if (self.textB) {
                self.textB();
            }
            //刚到语音
            self.showType=SHChatBarTypeShowVoice;
            self.voiceButton.selected=YES;
            self.voiceRecordButton.hidden=NO;
            [self.textView resignFirstResponder];
            self.textView.hidden=YES;

        }else{
            
            if (self.voiceB) {
                self.voiceB();
            }
            self.showType=SHChatBarTypeshowKeyBoard;
            self.voiceButton.selected=NO;
            self.voiceRecordButton.hidden=YES;
            self.textView.hidden=NO;
            [self.textView becomeFirstResponder];
          
        }
        
      
    }else if (aButton==self.faceButton){//发送按钮点击
        self.showType=SHChatBarTypeshowSendText;
        
        if ([self.delegate respondsToSelector:@selector(chatBarOfSend:)]) {
            [self.delegate chatBarOfSend:self.textView.text];
        }
        
     
    }else if (aButton==self.otherButton){//加号点击
        self.showType=SHChatBarTypeshowOtherView;
		self.otherButton.selected = !self.otherButton.isSelected;
        [self.textView resignFirstResponder];
		if (self.otherButton.isSelected == YES) {
			[[NSNotificationCenter defaultCenter] postNotificationName:KNotifactionShowChooseView object:nil];
		} else {
			[[NSNotificationCenter defaultCenter] postNotificationName:KNotifactionHiddenChooseView object:nil];
		}
		

     
    }
    
    
}





-(void)ClickLongPress:(UILongPressGestureRecognizer*)gesture{
    if (gesture.state==UIGestureRecognizerStateBegan) {
        MyLog(@"1");
    }else if (gesture.state==UIGestureRecognizerStateEnded){
        MyLog(@"结束");
    }
    
    
    if ([self.delegate respondsToSelector:@selector(chatBarOfVoice:)]) {
        [self.delegate chatBarOfVoice:gesture];
    }
    
}

@end
