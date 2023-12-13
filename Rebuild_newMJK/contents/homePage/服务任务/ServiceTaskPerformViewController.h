//
//  ServiceTaskPerformViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/4/14.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKOrderMoneyListModel.h"

@interface ServiceTaskPerformViewController : DBBaseViewController
@property (nonatomic, strong) NSString *C_ID;
/** 轨迹完成*/
@property (nonatomic, strong) NSString *trajectoryType;
/** MJKOrderMoneyListModel*/
@property (nonatomic, strong) MJKOrderMoneyListModel *moneyModel;
/** <#备注#>*/
@property (nonatomic, strong) NSString *vcName;
/** <#备注#>*/
@property (nonatomic, weak) UIViewController *rootVC;
@end
