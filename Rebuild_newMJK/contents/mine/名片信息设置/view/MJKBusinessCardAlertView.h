//
//  MJKBusinessCardAlertView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKBusinessCardAlertView : UIView
- (instancetype)initAlertControllerWithTitle:(NSString *)title message:(NSString *)message buttonArray:(NSArray *)buttonArray colorArray:(NSArray *)colorArray clickActionBlock:(void (^)(NSString * _Nonnull buttonTitle))actionBlock;
@property (nonatomic, copy) void(^closeViewActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
