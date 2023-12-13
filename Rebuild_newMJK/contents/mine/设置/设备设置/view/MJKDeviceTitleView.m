//
//  MJKDeviceTitleView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/31.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKDeviceTitleView.h"

@implementation MJKDeviceTitleView

- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArray {
	if (self = [super initWithFrame:frame]) {
		[self initUIWithTitleArray:titleArray];
	}
	return self;
}

- (void)initUIWithTitleArray:(NSArray *)titleArray {
	self.backgroundColor = kBackgroundColor;
	CGFloat width = KScreenWidth / titleArray.count;
	for (int i = 0; i < titleArray.count; i++) {
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, self.frame.size.height)];
		label.text = titleArray[i];
		label.textColor = [UIColor darkGrayColor];
		[self addSubview:label];
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:14.f];
	}
}

@end
