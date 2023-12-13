//
//  MJKSetLabel.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKSetLabel.h"

@implementation MJKSetLabel
+ (instancetype)setLabelWithFrame:(CGRect)frame andColor:(UIColor *)textColor andFont:(UIFont *)font andText:(NSString *)text {
    MJKSetLabel *szkLabel=[[MJKSetLabel alloc]initWithFrame:frame];
    szkLabel.text=text;
    szkLabel.textColor=textColor;
    szkLabel.font=font;
    szkLabel.textAlignment=NSTextAlignmentCenter;
//    szkLabel.backgroundColor=bgColor;
    return szkLabel;
}

@end
