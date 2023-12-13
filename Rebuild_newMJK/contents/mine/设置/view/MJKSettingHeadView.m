//
//  MJKSettingHeadView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKSettingHeadView.h"

@implementation MJKSettingHeadView

- (void)setHeadTitleArray:(NSArray *)headTitleArray {
	_headTitleArray = headTitleArray;
	self.backgroundColor = DBColor(239, 239, 244);
	for (int i = 0; i < headTitleArray.count; i++) {
		CGFloat width = (KScreenWidth - 40) / headTitleArray.count;
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width * i + 20, (self.frame.size.height - 20) / 2, width, 20)];
		label.text = headTitleArray[i];
		if (i == 0) {
			label.textAlignment = NSTextAlignmentLeft;
		} else if (i == headTitleArray.count - 1) {
			label.textAlignment = NSTextAlignmentRight;
		} else {
			label.textAlignment = NSTextAlignmentCenter;
		}
		label.font = [UIFont systemFontOfSize:14.0f];
		label.textColor = DBColor(142, 142, 142);
		[self addSubview:label];
	}
}

@end
