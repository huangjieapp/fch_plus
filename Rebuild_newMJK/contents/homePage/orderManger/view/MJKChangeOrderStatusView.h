//
//  MJKChangeOrderStatusView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCOrderDetailModel;

@interface MJKChangeOrderStatusView : UIView
- (instancetype)initWithFrame:(CGRect)frame andTitleNameArr:(NSArray *)titleArr andRootVC:(UIViewController *)rootVC;

@property (nonatomic, strong) NSString *projectManagerID;
@property (nonatomic, strong) NSString *projectManager;

@property (nonatomic,strong) CGCOrderDetailModel * detailModel;
/** <#注释#> */
@property (nonatomic,strong) NSString *typeStr;
/** <#注释#> */
@property (nonatomic,strong) NSString *statusName;
/** 设计师*/

@property (nonatomic, strong) NSString *C_DESIGNER_ROLEID;
@property (nonatomic, strong) NSString *C_DESIGNER_ROLENAME;
@property (nonatomic, strong) UIViewController *rootVC;
@property (nonatomic, strong) NSString *VCName;
@property (nonatomic, strong) NSMutableDictionary *qianyueDic;
/** order id*/
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *C_A41500_C_ID;

/** 到货和完工的状态*/
@property (nonatomic, strong) NSString *stateName;
@property (nonatomic, strong) void(^doneButtonBlock)(NSString *row0Str, NSString *row1str, NSString *timeStr, NSString *imageStr, NSString *categoryID, NSString *finshTime,NSString *orderMoney,NSString *C_MANAGER_ROLEID, NSString *B_MONEY, NSString *B_CASHDISCOUNT, NSString *B_GUIDEPRICE,NSString *payC_STATUS_DD_ID, NSString *principalID, NSString *C_PAYCHANNEL, NSString *C_MERCHANT_ORDER_NO, NSString *row1Str, NSString *startStr, NSString *yjAddress, NSString *fdjqh, NSString *cksj);
@property (nonatomic, strong) void(^backViewBlock)(NSString *str);
@end
