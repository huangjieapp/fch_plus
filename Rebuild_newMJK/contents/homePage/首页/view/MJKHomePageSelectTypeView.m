//
//  MJKHomePageSelectTypeView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/26.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKHomePageSelectTypeView.h"
@interface MJKHomePageSelectTypeView ()
@property (weak, nonatomic) IBOutlet UIView *selectView;
/** per button*/
@property (nonatomic, strong) UIButton *perButton;


@end

@implementation MJKHomePageSelectTypeView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.perButton = self.typeButtonArray[0];
	
}

- (void)setFrame:(CGRect)frame {
	frame.size = CGSizeMake(KScreenWidth, 50);
	[super setFrame:frame];
}

- (IBAction)typeAction:(UIButton *)sender {
//	CGRect frame = self.selectView.frame;
//	frame.origin.x = sender.frame.origin.x;
//	frame.size.width = sender.frame.size.width;
//	self.selectView.frame = frame;
    self.selectView.centerX=sender.centerX;
	if (self.typeSelectBlock) {
		self.typeSelectBlock(sender.titleLabel.text);
	}
	
	[sender setTitleColor:[UIColor blackColor]];
	[self.perButton setTitleColor:[UIColor darkGrayColor]];
	
	self.perButton = sender;
}

@end
