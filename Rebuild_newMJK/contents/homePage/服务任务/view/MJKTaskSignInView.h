//
//  MJKTaskSignInView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/9.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTaskSignInView : UIView
/** <#备注#>*/
@property (nonatomic, strong) UIViewController *rootVC;
/** imageBlock*/
@property (nonatomic, copy) void(^chooseBlock)(NSArray *imageArr);
- (void)createAddImageView;
@end

NS_ASSUME_NONNULL_END
