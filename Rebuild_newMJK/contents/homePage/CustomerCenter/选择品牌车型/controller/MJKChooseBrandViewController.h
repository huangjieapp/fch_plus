//
//  MJKChooseBrandViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/12/31.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKChooseBrandViewController : UIViewController
/** <#注释#>*/
@property (nonatomic, weak) UIViewController *rootVC;

@property (nonatomic, copy) void(^chooseProductBlock)(NSArray *productArray);
@end

NS_ASSUME_NONNULL_END
