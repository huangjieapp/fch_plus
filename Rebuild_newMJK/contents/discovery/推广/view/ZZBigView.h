//
//  ZZBigView.h
//  uliaobao
//
//  Created by wisdom on 16/6/20.
//  Copyright © 2016年 CGC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZBigView : UIScrollView


@property (nonatomic, strong)UIPageControl *bigPageControl;

- (instancetype)initWithFrame:(CGRect)frame withURLs:(NSArray *)urlArr with:(NSInteger)indexrow;;


- (void)show;


@end
