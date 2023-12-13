//
//  ZZSubBigView.h
//  uliaobao
//
//  Created by wisdom on 16/6/21.
//  Copyright © 2016年 CGC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZSubBigView;

@protocol ZZSubBigViewDelegate <NSObject>

- (void)stopCollection:(ZZSubBigView *)subView;

- (void) getScale:(ZZSubBigView *)subView goWith:(CGFloat)scale;

@end

@interface ZZSubBigView : UIView

@property (nonatomic,weak)id<ZZSubBigViewDelegate>delegate;

@property (nonatomic, strong)UIScrollView *myScroll;


- (instancetype)initWithdelegate:(id<ZZSubBigViewDelegate>)delegate withframe:(CGRect)frame withURL:(NSString *)url;


@end
