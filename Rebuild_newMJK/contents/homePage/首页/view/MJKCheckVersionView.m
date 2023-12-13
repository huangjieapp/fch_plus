//
//  MJKCheckVersionView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/29.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKCheckVersionView.h"

@interface MJKCheckVersionView ()

@end

@implementation MJKCheckVersionView
- (IBAction)updateButtonAction:(UIButton *)sender {
	if (self.updateButtonActioBlock) {
		self.updateButtonActioBlock();
	}
	[self removeFromSuperview];
}

- (void)setFrame:(CGRect)frame {
	frame.size = CGSizeMake(KScreenWidth, KScreenHeight);
	[super setFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
