//
//  MJKCustomerChooseViewController.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2023/5/15.
//  Copyright © 2023 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCCustomModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKCustomerChooseViewController : DBBaseViewController
/** <#注释#> */
@property (nonatomic, weak) UIViewController *rootVC;
/** <#注释#>*/
@property (nonatomic, copy) void(^chooseCustomerBlock)(CGCCustomModel *cmodel);
@end

NS_ASSUME_NONNULL_END
