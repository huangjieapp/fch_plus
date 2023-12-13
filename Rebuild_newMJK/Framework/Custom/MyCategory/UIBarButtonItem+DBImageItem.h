//
//  UIBarButtonItem+DBImageItem.h
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/19.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DBImageItem)
/** 图片创建Item  按图片大小创建的item*/
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage isLeft:(BOOL)isLeft target:(id)target andAction:(SEL)action;

+ (instancetype)MyitemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target andAction:(SEL)action;
@end
