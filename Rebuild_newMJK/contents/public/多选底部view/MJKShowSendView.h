//
//  MJKShowSendView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/17.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKShowSendView : UIView
- (instancetype)initWithFrame:(CGRect)frame andButtonTitleArray:(NSArray *)buttonArray andTitle:(NSString *)titleStr andMessage:(NSString *)message;
/** 点背景不可关闭*/
@property (nonatomic, assign) BOOL isFkr;
/** 按钮返回*/
@property (nonatomic, copy) void(^buttonActionBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
