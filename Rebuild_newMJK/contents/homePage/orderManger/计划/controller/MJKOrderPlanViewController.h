//
//  MJKOrderPlanViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/24.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGCOrderDetailModel.h"
#import "MJKOrderMoneyListModel.h"

@interface MJKOrderPlanViewController : DBBaseViewController
/** vc*/
@property (nonatomic, strong) UIViewController *rootVC;
/** vc name*/
@property (nonatomic, strong) NSString *vcName;
/** 轨迹id*/
@property (nonatomic, strong) NSString *trajectoryID;
/** 备注*/
@property (nonatomic, strong) NSString *remarkStr;
@property (nonatomic,strong) CGCOrderDetailModel *detailModel;
@property (nonatomic,strong) MJKOrderMoneyListModel *moneyModel;
@end
