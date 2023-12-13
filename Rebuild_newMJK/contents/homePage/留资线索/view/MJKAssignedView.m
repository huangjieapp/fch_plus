//
//  MJKAssignedView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/4.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKAssignedView.h"

@implementation MJKAssignedView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self creatAssignedView:frame];
	}
	return self;
}


- (void)creatAssignedView:(CGRect)frame {
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
	view.backgroundColor = DBColor(252, 202, 75);
	[self addSubview:view];
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
	cancelButton.frame = CGRectMake(10, 5, 60, 20);
	[cancelButton setTitle:@"取消" forState:UIControlStateNormal];
	[cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(endAssigned:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:cancelButton];
	self.allButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.allButton.frame = CGRectMake(70, 5, 60, 20);
	[self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.allButton setTitle:@"全选" forState:UIControlStateNormal];
	[self.allButton addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:self.allButton];
	UIButton *trueButton = [UIButton buttonWithType:UIButtonTypeSystem];
	trueButton.frame = CGRectMake(frame.size.width - 70, 5, 60, 20);
	[trueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[trueButton setTitle:@"确定" forState:UIControlStateNormal];
	[trueButton addTarget:self action:@selector(trueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:trueButton];
	
}

- (void)endAssigned:(UIButton *)sender {
	if (self.closeAssignedBlock) {
		self.closeAssignedBlock();
	}
	[self removeFromSuperview];
}

- (void)allSelectAction:(UIButton *)sender {
	if (self.allSelectBlock) {
		self.allSelectBlock();
	}
}

- (void)trueButtonAction:(UIButton *)sender {
	if (self.trueBlock) {
		self.trueBlock();
	}
}

@end
