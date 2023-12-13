//
//  ServiceTaskViewController.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/26.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceTaskSubModel;


@interface ServiceTaskViewController : DBBaseViewController

@property (nonatomic, strong) NSString *ORDER_TIME;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *ORDER_TIME_END;
/** <#注释#>*/
@property (nonatomic, strong) NSString *END_TIME_TYPE;
/** <#注释#>*/
@property (nonatomic, strong) NSString *END_END_TIME;
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;

@property (nonatomic, copy) void(^chooseTaskBlock)(ServiceTaskSubModel *model);

@end
