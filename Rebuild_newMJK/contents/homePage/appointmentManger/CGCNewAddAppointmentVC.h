//
//  CGCNewAddAppointmentVC.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/30.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "DBBaseViewController.h"
typedef void(^RELOADTABLEBLOCK)();

@class CGCAppointmentModel;
@interface CGCNewAddAppointmentVC : DBBaseViewController

@property (nonatomic, strong) NSMutableArray * sellArr;

@property (nonatomic,strong) CGCAppointmentModel * amodel;  //选好客户进来 新增预约

@property (nonatomic, copy) RELOADTABLEBLOCK rloadBlock;
/** <#注释#>*/
@property (nonatomic, weak) UIViewController *rootVC;
/** 订单编号 只有在订单值传*/
@property (nonatomic, strong) NSString *C_A42000_C_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *assitStr;
@end
