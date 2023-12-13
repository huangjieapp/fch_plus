//
//  HistoryDetailView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/10.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "HistoryDetailView.h"

@interface HistoryDetailView ()
@end

@implementation HistoryDetailView

- (instancetype)initWithFrame:(CGRect)frame andTimeAndRemark:(NSArray *)arr {
	if (self = [super initWithFrame:frame]) {
		[self initUIWithFrame:frame andTimeAndRemark:arr];
	}
	return self;
}

- (void)initUIWithFrame:(CGRect)frame andTimeAndRemark:(NSArray *)arr {
	UIView *bgView = [[UIView alloc]initWithFrame:frame];
	bgView.backgroundColor = [UIColor blackColor];
	bgView.alpha = 0.3f;
	
	UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeViwe)];
	[bgView addGestureRecognizer:tapGR];
	[self addSubview:bgView];
	NSString *str =arr[1];
	CGSize size = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 40 - 40, 9999.f) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
	UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(20, (KScreenHeight - size.height - 20) / 2, KScreenWidth - 40, size.height + 40)];
	detailView.backgroundColor = [UIColor whiteColor];
	[self addSubview:detailView];
	
	UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, detailView.frame.size.width, 20)];
	timeView.backgroundColor = DBColor(240, 240, 240);
	[detailView addSubview:timeView];
	
	//时间
	UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, timeView.frame.size.width - 40, 20)];
	timeLabel.text = arr[0];
	timeLabel.font = [UIFont systemFontOfSize:13.f];
	timeLabel.textColor = DBColor(144, 144, 144);
	[timeView addSubview:timeLabel];
	
	//操作记录内容
	UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(timeView.frame) + 10, detailView.frame.size.width - 40, size.height)];
	contentLabel.text = str;
	contentLabel.textColor = [UIColor blackColor];
	contentLabel.font = [UIFont systemFontOfSize:14.f];
	contentLabel.numberOfLines = 0;
	[detailView addSubview:contentLabel];
	
	//关闭
	UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(detailView.frame.size.width - 30, 0, 20, 20)];
	[closeButton setTitle:@"X" forState:UIControlStateNormal];
	[closeButton setTitleColor:DBColor(240, 194, 46) forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(closeViwe) forControlEvents:UIControlEventTouchUpInside];
	[detailView addSubview:closeButton];
}

- (void)closeViwe {
	[self removeFromSuperview];
}

@end
