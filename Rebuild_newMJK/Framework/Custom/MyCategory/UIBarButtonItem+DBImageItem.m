//
//  UIBarButtonItem+DBImageItem.m
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/19.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "UIBarButtonItem+DBImageItem.h"

@implementation UIBarButtonItem (DBImageItem)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage isLeft:(BOOL)isLeft target:(id)target andAction:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button  setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    button.bounds = (CGRect){CGPointZero, [button backgroundImageForState:UIControlStateNormal].size};
	if (isLeft == YES) {
		button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
	} else {
//		button.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
	}
	
	button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
 
    return [[self alloc] initWithCustomView:button];
}
+ (instancetype)MyitemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target andAction:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button  setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.bounds = (CGRect){CGPointZero, [button imageForState:UIControlStateNormal].size};
//    button.frame=CGRectMake(0, 0, 44, 44);
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    button.imageEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    return [[self alloc] initWithCustomView:button];

}

@end
