//
//  MJKFlowMeterDetailModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/10.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKFlowMeterDetailModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_A41500_C_ID;//
@property (nonatomic, strong) NSString *C_A41500_C_NAME;
@property (nonatomic, strong) NSString *C_AGE;//
@property (nonatomic, strong) NSString *C_ARRIVAL_DD_ID;//
@property (nonatomic, strong) NSString *C_ARRIVAL_DD_NAME;
@property (nonatomic, strong) NSString *C_HEADPIC;//
@property (nonatomic, strong) NSString *C_ID;//
@property (nonatomic, strong) NSString *C_RESULT_DD_ID;//
@property (nonatomic, strong) NSString *C_RESULT_DD_NAME;
@property (nonatomic, strong) NSString *C_SALEID;//
@property (nonatomic, strong) NSString *C_SALENAME;
@property (nonatomic, strong) NSString *C_SEX;//
@property (nonatomic, strong) NSString *D_ARRIVAL_TIME;//
@property (nonatomic, strong) NSString *D_BEFORE_TIME;//
@property (nonatomic, strong) NSString *I_ARRIVAL;//
@property (nonatomic, strong) NSString *C_POSITION;//
@property (nonatomic, strong) NSString *C_A41500_C_SEX_DD_ID;//
@property (nonatomic, strong) NSString *C_A41500_C_SEX_DD_NAME;//
@property (nonatomic, strong) NSString *C_A41200_C_ID;//
@property (nonatomic, strong) NSString *C_A41200_C_NAME;//
@property (nonatomic, strong) NSString *C_A41500_C_PHONE;//
@property (nonatomic, strong) NSString *C_A41500_C_WECHAT;//
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_ID;//
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_NAME;//
@property (nonatomic, strong) NSString *C_LEVEL_DD_ID;//
@property (nonatomic, strong) NSString *C_LEVEL_DD_NAME;//
@property (nonatomic, strong) NSString *C_OWNER_ROLEID;//
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;//
@property (nonatomic, strong) NSString *C_PHONE;//
@property (nonatomic, strong) NSString *C_REMARK_TYPE_DD_ID;//
@property (nonatomic, strong) NSString *C_REMARK_TYPE_DD_NAME;//
@property (nonatomic, strong) NSString *C_SOURCE_DD_ID;//
@property (nonatomic, strong) NSString *C_SOURCE_DD_NAME;//
@property (nonatomic, strong) NSString *C_STAGE_DD_ID;//
@property (nonatomic, strong) NSString *C_STAGE_DD_NAME;//
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;//
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;//
@property (nonatomic, strong) NSString *D_LASTFOLLOW_TIME;//
@property (nonatomic, strong) NSString *I_PEPOLE_NUMBER;//
@property (nonatomic, strong) NSString *X_REMARK;//
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_WECHAT;

/** 随行人员*/
@property (nonatomic, strong) NSString *C_ATTENDANT;
/** 逗留时间code*/
@property (nonatomic, strong) NSString *C_STAYTIME_DD_ID;
/** 逗留时间*/
@property (nonatomic, strong) NSString *C_STAYTIME_DD_NAME;
/** 如果这个userid和登入账号相同或者为空串，才可对记录做操作。
 本次接待人id*/
@property (nonatomic, strong) NSString *USERID;
/** 本次接待人姓名*/
@property (nonatomic, strong) NSString *USERNAME;
/** 本次操作时间*/
@property (nonatomic, strong) NSString *D_OPERATION_TIME;

/** <#注释#>*/
@property (nonatomic, strong) NSArray *headpic_content;
/** 返回VIP带V
 返回HEART带心
 其他返回空串*/
@property(nonatomic,strong) NSString *LEVEL;
/** 流量备注*/
@property (nonatomic, strong) NSString *X_A41300_REMARK;
@end
