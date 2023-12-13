//
//  MJKMessageTextView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/17.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKMessageTextView : UIView
- (instancetype)initWithStartPoint:(CGPoint)point contentWidth:(CGFloat)contentWidth text:(NSString *)textMessage font:(UIFont *)font textColor:(UIColor *)textColor lineGap:(CGFloat)lineGap wordGap:(CGFloat)wordGap  inputLocations:(NSArray *)locationArray;
@end

NS_ASSUME_NONNULL_END
