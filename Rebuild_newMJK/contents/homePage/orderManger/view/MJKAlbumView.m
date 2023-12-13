//
//  MJKAlbumView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAlbumView.h"

@interface MJKAlbumView (){
	NSInteger imageCount;
	UIImageView *imageView;
	UIScrollView *scrollView;
	NSArray *dataArray;
	NSIndexPath *indexPath;
}
@end

@implementation MJKAlbumView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initUI];
	}
	return self;
}

- (void)initUI {
	UIView *bgview = [[UIView alloc]initWithFrame:self.frame];
	bgview.backgroundColor = [UIColor blackColor];
	[self addSubview:bgview];
	UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeImage)];
//	[bgview addGestureRecognizer:tapGR];
	scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
	[self addSubview:scrollView];
	[scrollView addGestureRecognizer:tapGR];
	
	
}

- (void)reloadData {
	if ([_delegate respondsToSelector:@selector(numberOfImageCount)]) {
		imageCount = [_delegate numberOfImageCount];
	}
	
	if ([_delegate respondsToSelector:@selector(imageDataArrayWithIndexPath)]) {
		dataArray = [_delegate imageDataArrayWithIndexPath];
	}
	[imageView removeFromSuperview];
	for (int i = 0; i < dataArray.count; i++) {
		imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * KScreenWidth, 0, KScreenWidth , KScreenHeight)];
		[imageView sd_setImageWithURL:[NSURL URLWithString:dataArray[i]]];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		[scrollView addSubview:imageView];
	}
	
//	[imageView addGestureRecognizer:tapGR];
	
	scrollView.pagingEnabled = YES;
	scrollView.contentSize = CGSizeMake(KScreenWidth *imageCount, KScreenHeight);
	scrollView.contentOffset = CGPointMake(KScreenWidth *_row, 0) ;
	
}

- (void)closeImage {
	[self removeFromSuperview];
}

@end
