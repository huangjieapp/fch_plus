//
//  MJKNewTaskListViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/12.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceTaskSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKNewTaskListViewController : DBBaseViewController
@property (nonatomic, strong) NSString *ORDER_TIME;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *ORDER_TIME_END;
/** <#注释#>*/
@property (nonatomic, strong) NSString *END_TIME_TYPE;
/** <#注释#>*/
@property (nonatomic, strong) NSString *END_END_TIME;
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;

/** <#注释#>*/
@property (nonatomic, strong) NSString *C_A41500_DD_ID;
@property (nonatomic, copy) void(^chooseTaskBlock)(ServiceTaskSubModel *model);;
@end

NS_ASSUME_NONNULL_END
