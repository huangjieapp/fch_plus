//
//  MJKCustomReturnSubModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKCustomReturnSubModel : MJKBaseModel
//TODO:线索，业绩，回访等级共用model
@property (nonatomic, strong) NSString *C_ID;

//回访等级 / 线索
@property (nonatomic, strong) NSString *C_NAME;//类型

//回访等级
@property (nonatomic, strong) NSString *I_NUMBER;//天数

/** 状态id*/
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
/** 状态*/
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;

//线索
@property (nonatomic, strong) NSString *FLAG;//是否选中
@property (nonatomic, getter=isSelected) BOOL selected;

/** 任务排班设置的，这里返回userid，以逗号隔开*/
@property (nonatomic, strong) NSString *X_REMARK;
/** 任务排班设置的，这里返回userid，以逗号隔开 订单默认员工设置*/
@property (nonatomic, strong) NSString *X_REMARKNAME;
/** 自定义推送人List/任务排班人的List*/
@property (nonatomic, strong) NSArray *customList;
/** 返回0不开启短信通知
 返回1开启短信通知*/
@property (nonatomic, assign) int I_TYPE;
@property (nonatomic, assign) int I_WECHAT;
@property (nonatomic, assign) int I_JGTS;
/** 默认推送List*/
@property (nonatomic, strong) NSArray *defaultList;
/** 第一次推送时间（固定格式如下午2点，传14:00）
 返回空串表示未开启*/
@property (nonatomic, strong) NSString *C_FIRSTPUSH;
/** 第二次推送时间（固定格式如下午2点，传14:00）
 返回空串表示未开启*/
@property (nonatomic, strong) NSString *C_SECONDPUSH;
/** 第三次推送时间（固定格式如下午2点，传14:00）
 返回空串表示未开启*/
@property (nonatomic, strong) NSString *C_THIRDPUSH;
/** 配置项code*/
@property (nonatomic, strong) NSString *C_VOUCHERID;
/** 达标值（奖励门槛）*/
@property (nonatomic, strong) NSString *I_INDEXNUMBER;
/** 固定值（定额红包金额*/
@property (nonatomic, strong) NSString *B_FIXEDNUMBER;
/** 最小值（随机红包最小值）*/
@property (nonatomic, strong) NSString *B_MINNUMBER;
/** 最大值（随机红包最大值）*/
@property (nonatomic, strong) NSString *B_MAXNUMBER;
/** 细分类型CODE
 定额红包传A47500_C_XFTYPE_0000
 随机红包传A47500_C_XFTYPE_0001*/
@property (nonatomic, strong) NSString *C_XFTYPE_DD_ID;
//C_XFTYPE_DD_NAME
@property (nonatomic, strong) NSString *C_XFTYPE_DD_NAME;

@property (nonatomic, strong) NSString *C_KHPX;
@property (nonatomic, strong) NSString *IS_UPDATE;
@property (nonatomic, strong) NSString *X_FIRSTREMARK;
@property (nonatomic, strong) NSString *X_SECONDREMARK;

@end
