//
//  UIView+DBBorderView.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/9.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DBBorderView)

/// 边线颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
/// 边线宽度
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/// 圆角半径
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end
