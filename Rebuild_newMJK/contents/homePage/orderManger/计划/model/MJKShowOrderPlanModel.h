//
//  MJKShowOrderPlanModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKShowOrderPlanModel : MJKBaseModel
/** 轨迹id*/
@property (nonatomic, strong) NSString *C_ID;
/** 轨迹名称*/
@property (nonatomic, strong) NSString *C_NAME;
/** 状态id*/
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
/** 状态*/
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
/** 订单id*/
@property (nonatomic, strong) NSString *C_A42000_C_ID;
/** 计划时间*/
@property (nonatomic, strong) NSString *D_PLANNED_TIME;
/** 完成时间*/
@property (nonatomic, strong) NSString *D_ACTUAL_TIME;
/** 负责人*/
@property (nonatomic, strong) NSString *C_RESPONSIBLE_ROLEID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_RESPONSIBLE_ROLENAME;
/** 完成人*/
@property (nonatomic, strong) NSString *C_COMPLETE_ROLEID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_COMPLETE_ROLENAME;
/** 完成备注*/
@property (nonatomic, strong) NSString *X_REMARK;
/** 计划备注*/
@property (nonatomic, strong) NSString *X_PLANNEDREMARK;
/** 附件url的list*/
@property (nonatomic, strong) NSArray *urlList;
/** 任务id*/
@property (nonatomic, strong) NSString *C_A01200_C_ID;
/** 任务状态id*/
@property (nonatomic, strong) NSString *C_RWSTATUS_DD_ID;
/** 任务状态*/
@property (nonatomic, strong) NSString *C_RWSTATUS_DD_NAME;

/** 关联类型*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** 关联类型*/
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;

/** 是否未出*/
@property (nonatomic, strong) NSString *I_RWTYPE;

/** 轨迹的排序值，只能输入数字*/
@property (nonatomic, strong) NSString *I_SORTIDX;
/** 关联订单状态（typecode=“A42000_C_STATUS”）*/
@property (nonatomic, strong) NSString *C_A42000STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_A42000STATUS_DD_NAME;
//C_DYSJD_DD_ID
@property (nonatomic, strong) NSString *C_DYSJD_DD_ID;
@property (nonatomic, strong) NSString *C_DYSJD_DD_NAME;
//I_DYXS
@property (nonatomic, strong) NSString *I_DYXS;

@end
