//
//  addDealViewController.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/26.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKOrderMoneyListModel.h"
@class CGCOrderDetailModel;

@interface addDealViewController : DBBaseViewController
@property (nonatomic, strong) NSString *vcName;
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcType;
@property (nonatomic, strong) MJKOrderMoneyListModel *model;
/** <#注释#>*/
@property (nonatomic, strong) CGCOrderDetailModel *orderDetailModel;
//如果有 订单号  那就传   如果没有就不传
//服务工单 里面有
@property(nonatomic,strong)NSString*C_ORDER_ID;
/** <#注释#>*/
@property(nonatomic,strong) NSString *A04200_C_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *type;

/** <#备注#>*/
@property (nonatomic, copy) void(^reloadBlock)(void);

@end
