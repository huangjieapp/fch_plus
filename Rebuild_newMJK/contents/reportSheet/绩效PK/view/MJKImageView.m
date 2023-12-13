//
//  MJKImageView.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKImageView.h"

@implementation MJKImageView

+ (instancetype)loadImageViewWithFrame:(CGRect)frame andcornerRadius:(CGFloat)radius andImage:(NSString *)imageStr {
    MJKImageView *mjkImageView = [[MJKImageView alloc]initWithFrame:frame];
    mjkImageView.layer.masksToBounds = YES;
    mjkImageView.layer.cornerRadius = radius;
    mjkImageView.image = [UIImage imageNamed:imageStr];
    return mjkImageView;
}

@end
