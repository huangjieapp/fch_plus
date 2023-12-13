//
//  MJKWorkReportDetailModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKWorkReportDetailModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_ID;
/** 明细类型code*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** 明细类型名称*/
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
/** 单位*/
@property (nonatomic, strong) NSString *UNIT;
/** 数量*/
@property (nonatomic, strong) NSString *B_TOTAL;
/** 明细记录id（逗号隔开）*/
@property (nonatomic, strong) NSString *X_OBJECTIDS;
@property (nonatomic, getter=isSelected) BOOL selected;

/** flag*/
@property (nonatomic, assign) BOOL flag;


/** 今日计划数*/
@property (nonatomic, strong) NSString *B_TOTAL_JH;
/** 与B_TOTAL_JH字段同一个层的X_REMARK，返回的是数量细分后的备注*/
@property (nonatomic, strong) NSString *X_REMARK;

/** 明日计划数*/
@property (nonatomic, strong) NSString *B_TOTAL_JH_MR;

/** 本月目标数*/
@property (nonatomic, strong) NSString *I_TARGETNUMBER;

/** 本月完成数*/
@property (nonatomic, strong) NSString *B_TOTAL_BY;
@end
