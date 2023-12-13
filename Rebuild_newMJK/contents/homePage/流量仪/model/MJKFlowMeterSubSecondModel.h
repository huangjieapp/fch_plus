//
//  MJKFlowMeterSubSecondModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/9.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKFlowMeterSubSecondModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_AGE;
@property (nonatomic, strong) NSString *C_ARRIVAL_DD_ID;
@property (nonatomic, strong) NSString *C_HEADPIC;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_SEX;
@property (nonatomic, strong) NSString *D_ARRIVAL_TIME;
@property (nonatomic, strong) NSString *I_ARRIVAL;

/** 批次*/
@property (nonatomic, strong) NSString *pcCount;
/** 未处理数量*/
@property (nonatomic, strong) NSString *wfpCount;
/** 有效数量*/
@property (nonatomic, strong) NSString *yxCount;
/** 总数量*/
@property (nonatomic, strong) NSString *allCount;
/** 流量仪位置*/
@property (nonatomic, strong) NSString *C_POSITION;
/** 如果这个userid和登入账号相同或者为空串，才可对记录做操作。
 本次接待人id*/
@property (nonatomic, strong) NSString *USERID;
/** 上次接待销售员id*/
@property (nonatomic, strong) NSString *C_SALEID;
/** 上次接待销售员*/
@property (nonatomic, strong) NSString *C_SALENAME;
/** 上次处理时间*/
@property (nonatomic, strong) NSString *D_BEFORE_TIME;
/** 潜客姓名*/
@property (nonatomic, strong) NSString *C_A41500_C_NAME;
/** 潜客id*/
@property (nonatomic, strong) NSString *C_A41500_C_ID;
/** 本次接待人姓名*/
@property (nonatomic, strong) NSString *USERNAME;
/** 返回VIP带V
 返回HEART带心
 其他返回空串*/
@property (nonatomic, strong) NSString *LEVEL;

@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_ID;
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_NAME;
@property (nonatomic, strong) NSString *C_COMPOSE;
@property (nonatomic, strong) NSString *C_OWNER_ROLEID;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSString *C_SOURCE_DD_ID;
@property (nonatomic, strong) NSString *C_SOURCE_DD_NAME;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSString *FLAG;

@property (nonatomic, strong) NSString *guijiflag;
@property (nonatomic, strong) NSString *X_REMARK;

@property (nonatomic, getter=isSelected) BOOL selected;

@end
