//
//  MJKWorkReportListModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MJKWorkReportListModel : MJKBaseModel
/** 汇报id*/
@property (nonatomic, strong) NSString *C_ID;
/** 昨日计划*/
@property (nonatomic, strong) NSString *X_ZRPLAN;
/** 明日计划*/
@property (nonatomic, strong) NSString *X_MRPLAN;
/** 创建时间*/
@property (nonatomic, strong) NSString *D_CREATE_TIME;
/** 员工id*/
@property (nonatomic, strong) NSString *USERID;
/** 员工姓名*/
@property (nonatomic, strong) NSString *USERNAME;
/** 头像*/
@property (nonatomic, strong) NSString *C_HEADIMGURL;
/** 图片*/
@property (nonatomic, strong) NSArray *urlList;
/** 汇报明细*/
@property (nonatomic, strong) NSMutableArray *content;
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
/** 备注*/
@property (nonatomic, strong) NSString *X_REMARK;
/** 评论数*/
@property (nonatomic, strong) NSString *comments;
/** 点赞数*/
@property (nonatomic, strong) NSString *fabulous;
/** 已经点过赞返回true
 没点过返回false*/
@property (nonatomic, strong) NSString *fabulous_flag;
/** D_LASTUPDATE_TIME*/
@property (nonatomic, strong) NSString *D_LASTUPDATE_TIME;

/** 昨日计划明细内容文本*/
@property (nonatomic, strong) NSString *X_ZRPLANDETAILED;
/** ming日计划明细内容文本*/
@property (nonatomic, strong) NSString *X_MRPLANDETAILED;
/** 明日计划列表*/
@property (nonatomic, strong) NSArray *jrjhmx;
/** 明日计划明细类型code*/
@property (nonatomic, strong) NSString *CODE;
/** 明日计划明细类型名称*/
@property (nonatomic, strong) NSString *NAME;
/** 明日计划统计数*/
@property (nonatomic, strong) NSString *COUNT;

/** flag*/
@property (nonatomic, assign) BOOL flag;


/** 今日计划数*/
@property (nonatomic, strong) NSString *B_TOTAL_JH;
/** 与B_TOTAL_JH字段同一个层的X_REMARK，返回的是数量细分后的备注*/
//@property (nonatomic, strong) NSString *X_REMARK;

@property (nonatomic, getter=isSelected) BOOL selected;

@end
