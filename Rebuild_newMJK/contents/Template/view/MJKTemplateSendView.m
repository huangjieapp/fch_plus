//
//  MJKTemplateSendView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/19.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKTemplateSendView.h"

@interface MJKTemplateSendView ()<UITextViewDelegate>
/** textStr*/
@property (nonatomic, strong) NSString *textStr;
@end

@implementation MJKTemplateSendView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.messageTextView.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView {
	self.textStr = textView.text;
}

- (IBAction)cancelButtonAction:(id)sender {
	[self removeFromSuperview];
}
- (IBAction)saveButtonAction:(id)sender {
	if (self.saveBlock) {
		self.saveBlock(self.textStr);
		[self removeFromSuperview];
	}
}
- (IBAction)sendButtonAction:(id)sender {
	if (self.sendBlock) {
		self.sendBlock(self.textStr);
		[self removeFromSuperview];
	}
}

- (void)setFrame:(CGRect)frame  {
	frame.size = CGSizeMake(KScreenWidth, KScreenHeight);
	[super setFrame:frame];
}


@end
