//
//  MJKUpdatePasswordView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/11.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKUpdatePasswordView.h"

@interface MJKUpdatePasswordView ()
@property (weak, nonatomic) IBOutlet UITextField *firstTF;
@property (weak, nonatomic) IBOutlet UITextField *secondTF;
@property (weak, nonatomic) IBOutlet UITextField *thirdTF;

@end

@implementation MJKUpdatePasswordView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.size = CGSizeMake(KScreenWidth, KScreenHeight);
	UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirst)];
	[self addGestureRecognizer:tapGR];
}
- (void)resignFirst {
	[self.firstTF resignFirstResponder];
	[self.secondTF resignFirstResponder];
	[self.thirdTF resignFirstResponder];
}

- (IBAction)cancelButtonAction:(id)sender {
	[self removeFromSuperview];
}
- (IBAction)sureButtonAction:(id)sender {
	if (self.firstTF.text.length <= 0) {
		[JRToast showWithText:@"请输入原密码"];
		return;
	}
	if (self.secondTF.text.length <= 0) {
		[JRToast showWithText:@"请输入新密码"];
		return;
	}
	if (self.thirdTF.text.length <= 0) {
		[JRToast showWithText:@"请再次输入新密码"];
		return;
	}
	if (![self.secondTF.text isEqualToString:self.thirdTF.text]) {
		[JRToast showWithText:@"两次密码输入不一致"];
		return;
	}
	NSString*oldCode=[KUSERDEFAULT objectForKey:saveLoginCode];
	if (![self.firstTF.text isEqualToString:oldCode]) {
		[JRToast showWithText:@"旧密码输入错误"];
		return ;
	}

	[self resignFirst];
	
	if (self.backPasswordBlock) {
		self.backPasswordBlock(self.firstTF.text,self.secondTF.text);
	}
}

@end
