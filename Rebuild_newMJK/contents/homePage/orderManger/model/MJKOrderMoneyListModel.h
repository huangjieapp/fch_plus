//
//  MJKOrderMoneyListModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKOrderMoneyListModel : MJKBaseModel

//
/** 订单节点id*/
@property (nonatomic, strong) NSString *C_A47300_C_ID;
//订单跟踪
@property(nonatomic,strong) NSString * C_ID;
@property(nonatomic,strong) NSString * C_NAME;
@property(nonatomic,strong) NSString * D_LASTUPDATE_TIME;
@property(nonatomic,strong) NSString * C_STATUS_DD_ID;
@property(nonatomic,strong) NSString * C_STATUS_DD_NAME;
//@property(nonatomic,strong) NSString * X_REMARK;
@property(nonatomic,strong) NSString * I_SORTIDX;
@property(nonatomic,strong) NSString * C_A42000_C_ID;
@property(nonatomic,strong) NSString * TYPE;
@property(nonatomic,strong) NSArray * urlList;

//收款记录
@property(nonatomic,strong) NSString * C_A04200_C_ID;
@property(nonatomic,strong) NSString * D_CREATE_TIME;
@property(nonatomic,strong) NSString * X_REMARK;
@property(nonatomic,strong) NSString * C_PAYCHANNEL;
@property(nonatomic,strong) NSString * AMOUNT;
@property(nonatomic,strong) NSString * yfTotal;
//@property(nonatomic,strong) NSString * D_CREATE_TIME;
@property(nonatomic,strong) NSString * C_OWNER_ROLEID;
@property(nonatomic,strong) NSString * C_OWNER_ROLENAME;
@property(nonatomic,strong) NSString * D_CREATE_DATE;
@property(nonatomic,strong) NSString * C_A41500_C_ID;
@property(nonatomic,strong) NSString * C_A41500_C_NAME;
@property(nonatomic,strong) NSString * wfTotal;

@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;

/** <#注释#> */
@property (nonatomic, strong) NSString *B_AMOUNT;

//交付关怀
//@property(nonatomic,strong) NSString * C_ID;
@property(nonatomic,strong) NSString * D_FOLLOW_TIME;
@property(nonatomic,strong) NSString * CONTENT;
@property(nonatomic,strong) NSString * C_CREATOR_ROLEID;
@property(nonatomic,strong) NSString * C_CREATOR_ROLENAME;
/**任务id*/
@property(nonatomic,strong) NSString * C_A01200_C_ID;
/**任务类型id*/
@property(nonatomic,strong) NSString * C_RWTYPE_DD_ID;
/**任务类型名*/
@property(nonatomic,strong) NSString * C_RWTYPE_DD_NAME;
@property(nonatomic,strong) NSString *C_RWSTATUS_DD_ID;
@property(nonatomic,strong) NSString *C_RWSTATUS_DD_NAME;
/** 计划时间*/
@property (nonatomic, strong) NSString *D_PLANNED_TIME;
/** 完成时间*/
@property (nonatomic, strong) NSString *D_ACTUAL_TIME;
/** 负责人id*/
@property (nonatomic, strong) NSString *C_RESPONSIBLE_ROLEID;
/** 负责人*/
@property (nonatomic, strong) NSString *C_RESPONSIBLE_ROLENAME;
/** 完成人id*/
@property (nonatomic, strong) NSString *C_COMPLETE_ROLEID;
/** 完成人*/
@property (nonatomic, strong) NSString *C_COMPLETE_ROLENAME;
/** 计划备注*/
@property (nonatomic, strong) NSString *X_PLANNEDREMARK;
@property (nonatomic, strong) NSString *D_PLANNEDSTART_TIME;
/** <#注释#>*/
@property (nonatomic, strong) NSString *D_CONFIRMED_TIME;

/** 是否外出
 是返回1
 否返回0*/
@property (nonatomic, strong) NSString *I_RWTYPE;

@property(nonatomic,getter=isSelected) BOOL selected;
//所有附件
//@property(nonatomic,strong) NSArray * content;

@end
