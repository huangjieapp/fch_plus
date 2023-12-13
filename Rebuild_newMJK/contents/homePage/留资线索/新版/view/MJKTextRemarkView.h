//
//  MJKTextRemarkView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTextRemarkView : UIView

/** 输入的内容*/
@property (nonatomic, strong) NSString *inputStr;
/** 输入返回*/
@property (nonatomic, copy) void(^changeTextViewBlock)(NSString *str);

/** 按钮返回*/
@property (nonatomic, copy) void(^buttonActionBlock)(NSString *str, NSString *inputStr, NSString *timeStr);
@end

NS_ASSUME_NONNULL_END
