//
//  UIColor+HexColor.h
//  rhct_ios
//
//  Created by 66 on 15/1/21.
//  Copyright (c) 2015年 rhct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
/**
 *  @brief  获取UIColor色彩，根据Hex;
 *
 *  @param hexString 字符串（Hex）;
 *
 *  @return UIColor
 */
+ (UIColor *) colorWithHexString: (NSString *) hexString;

//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
//获取16进制颜色的方法
+ (UIColor *)colorWithHex:(NSString *)hexColor;
@end
