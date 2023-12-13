//
//  MJKTelephoneRobotProcessModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTelephoneRobotProcessModel : MJKBaseModel
/** 电话任务明细id*/
@property (nonatomic, strong) NSString *C_ID;
/** 电话任务id*/
@property (nonatomic, strong) NSString *C_A70100_C_ID;
/** 电话任务名称*/
@property (nonatomic, strong) NSString *C_A70100_C_NAME;
/** 客户姓名*/
@property (nonatomic, strong) NSString *C_NAME;
/** 被叫号码*/
@property (nonatomic, strong) NSString *number;
/** 状态code*/
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
/** 状态*/
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
/** 业务数据id*/
@property (nonatomic, strong) NSString *C_OBJECTID;
/** 主叫号码*/
@property (nonatomic, strong) NSString *calleridnumber;
/** 开始呼叫的时间*/
@property (nonatomic, strong) NSString *calldatetime;
/** 通话时长*/
@property (nonatomic, strong) NSString *bill;
/** 呼叫耗时*/
@property (nonatomic, strong) NSString *duration;
/** 录音链接*/
@property (nonatomic, strong) NSString *C_LYURL;
/** 通话意向*/
@property (nonatomic, strong) NSString *intentionDesc;
/** 挂断原因*/
@property (nonatomic, strong) NSString *daStr;
/** 通话文本
 botContent机器人文本
 chatContent客户文本*/
@property (nonatomic, strong) NSArray *data;
/** 业务数据状态code*/
@property (nonatomic, strong) NSString *C_OBJECTSTATUSID;
/** 业务数据状态*/
@property (nonatomic, strong) NSString *C_OBJECTSTATUSNAME;
/** 业务数据所属人姓名*/
@property (nonatomic, strong) NSString *C_OBJECTOWNERROLENAME;
/** 号码来源code*/
@property (nonatomic, strong) NSString *C_SOURCE_DD_ID;
/** 号码来源*/
@property (nonatomic, strong) NSString *C_SOURCE_DD_NAME;
@end

NS_ASSUME_NONNULL_END
