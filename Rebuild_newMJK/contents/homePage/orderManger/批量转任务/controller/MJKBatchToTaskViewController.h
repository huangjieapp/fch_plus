//
//  MJKBatchToTaskViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/15.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCOrderDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKBatchToTaskViewController : UIViewController
/** <#注释#>*/
@property (nonatomic, strong) CGCOrderDetailModel *orderModel;
/** <#注释#>*/
@property (nonatomic, strong) NSString *remarkStr;
/** <#注释#>*/
@property (nonatomic, strong) NSString *orderId;

/** 筛选条件：订单状态
 （typecode=“A42000_C_STATUS”）*/
@property (nonatomic, strong) NSString *C_A42000STATUS_DD_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *user_id;
/** <#注释#>*/
@property (nonatomic, strong) NSString *user_name;
@end

NS_ASSUME_NONNULL_END
