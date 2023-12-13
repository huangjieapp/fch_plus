//
//  HeadImageView.h
//  uliaobao
//
//  Created by pop on 15/6/16.
//  Copyright (c) 2015年 CGC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeadImageView;
@protocol HeadImageViewDelegate<NSObject>

- (void)headView:(HeadImageView*)headcolleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
/**页数从1开始*/
- (void)nowpag:(NSInteger)page;
@end
/**轮播视图*/
@interface HeadImageView : UIView
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic) BOOL isUserTouch;
@property (nonatomic,weak) id<HeadImageViewDelegate>deleagte;
@property (nonatomic) NSInteger currentPage;
/**是否显示页书*/
@property (nonatomic) BOOL showPageControl;
@property (nonatomic)  UIViewContentMode imageMode;
@property(nonatomic,strong) UIPageControl * pageControl;
@property(nonatomic,strong) UIImage * ploadImage;
- (void)makecurentView;
@property(nonatomic,assign)  NSTimer*timer;

//是否显示水印
@property (nonatomic,assign)BOOL isShowWater;
@end
