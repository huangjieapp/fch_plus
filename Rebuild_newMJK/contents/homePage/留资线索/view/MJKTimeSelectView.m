//
//  MJKTimeSelectView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKTimeSelectView.h"

@interface MJKTimeSelectView ()
@end

@implementation MJKTimeSelectView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self createTimeView:frame];
	}
	return self;
}

- (void)createTimeView:(CGRect)frame {
	UIView *background = [[UIView alloc]initWithFrame:frame];
	[self addSubview:background];
	background.backgroundColor = [UIColor clearColor];
	background.alpha = 0.5;
	
	UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMidY(background.frame) - 64, frame.size.width - 20, 150)];
	[self addSubview:selectView];
	selectView.backgroundColor = [UIColor whiteColor];
	selectView.layer.cornerRadius = 5.0f;
	
	UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, selectView.frame.size.width - 60, 30)];
	[selectView addSubview:titleLabel];
	titleLabel.text = @"自定义时间";
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.textColor = [UIColor grayColor];
	titleLabel.font = [UIFont systemFontOfSize:14.0f];
	
	UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 50, selectView.frame.size.width - 60, 30)];
	[selectView addSubview:startButton];
	[startButton setTitle:@"请选择开始时间" forState:UIControlStateNormal];
	startButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	[startButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	startButton.layer.cornerRadius = 5.0f;
	startButton.layer.borderWidth = 1;
	startButton.layer.borderColor = [UIColor grayColor].CGColor;
	[startButton addTarget:self action:@selector(startTimeAction:) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *endButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 100, selectView.frame.size.width - 60, 30)];
	[selectView addSubview:endButton];
	[endButton setTitle:@"请选择结束时间" forState:UIControlStateNormal];
	endButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	[endButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	endButton.layer.cornerRadius = 5.0f;
	endButton.layer.borderWidth = 1;
	endButton.layer.borderColor = [UIColor grayColor].CGColor;
	[endButton addTarget:self action:@selector(endTimeAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startTimeAction:(UIButton *)sender {
	[self createAlertSheet];
}

- (void)endTimeAction:(UIButton *)sender {
	
}

- (void)createAlertSheet {
	UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"开始时间" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	[self.viewController presentViewController:alertVC animated:YES completion:nil];
	
}

@end
