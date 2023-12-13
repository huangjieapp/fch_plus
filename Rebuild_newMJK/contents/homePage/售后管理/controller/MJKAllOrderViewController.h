//
//  MJKAllOrderViewController.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2023/5/15.
//  Copyright © 2023 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCOrderDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKAllOrderViewController : UIViewController
/** <#注释#> */
@property (nonatomic, strong) NSString *C_A41500_C_ID;
/** <#注释#>*/
@property (nonatomic, copy) void (^chooseOrderBlock)(CGCOrderDetailModel *orderModel);
@end

NS_ASSUME_NONNULL_END
