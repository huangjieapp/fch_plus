//
//  MJKAddCustomerTheLabelView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/15.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKAddCustomerTheLabelView.h"

@interface MJKAddCustomerTheLabelView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLayout;
/** inputStr*/
@property (nonatomic, strong) NSString *inputStr;
@end

@implementation MJKAddCustomerTheLabelView

- (void)setFrame:(CGRect)frame {
	frame.size = CGSizeMake(KScreenWidth, KScreenHeight);
	[super setFrame:frame];
}

- (IBAction)textBeginEditTF:(UITextField *)sender {
	self.centerLayout.constant = -50;
}
- (IBAction)textEndEditTF:(UITextField *)sender {
	self.centerLayout.constant = 0;
}
- (IBAction)textChangeTextTF:(UITextField *)sender {
	self.inputStr = sender.text;
}
- (IBAction)cancelButtonAction:(id)sender {
	[self removeFromSuperview];
}
- (IBAction)submitButtonAction:(id)sender {
	if (self.inputStr.length <= 0) {
		[JRToast showWithText:@"请输入标签名称"];
		return;
	}
	if (self.inputLabelMessageBlock) {
		self.inputLabelMessageBlock(self.inputStr);
	}
	[self removeFromSuperview];
}

@end
