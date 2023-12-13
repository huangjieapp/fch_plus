//
//  MJKSetLabel.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKSetLabel : UILabel
+ (instancetype)setLabelWithFrame:(CGRect)frame andColor:(UIColor *)textColor andFont:(UIFont *)font andText:(NSString *)text;
@end
