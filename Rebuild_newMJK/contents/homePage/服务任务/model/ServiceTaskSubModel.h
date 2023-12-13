//
//  ServiceTaskSubModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/27.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceTaskSubModel : MJKBaseModel

@property(nonatomic,strong)NSString*C_A41500_C_ID;
@property(nonatomic,strong)NSString*C_A41500_C_NAME;   //客户名称
@property(nonatomic,strong)NSString*C_A42000_C_ID;   //订单id
@property(nonatomic,strong)NSString*C_ADDRESS;    //上门地址
@property(nonatomic,strong)NSString*C_CONTACTPHONE;  //客户电话
@property(nonatomic,strong)NSString*C_HEADIMGURL;   //客户头像
@property(nonatomic,strong)NSString*C_ID;
@property(nonatomic,strong)NSString*C_OWNER_ROLEID;     //不用
@property(nonatomic,strong)NSString*C_OWNER_ROLENAME;  //不用
@property(nonatomic,strong)NSString*C_STATUS_DD_ID;
@property(nonatomic,strong)NSString*C_STATUS_DD_NAME;   //状态
@property(nonatomic,strong)NSString*C_TYPE_DD_ID;
@property(nonatomic,strong)NSString*C_TYPE_DD_NAME;   //任务类型
@property(nonatomic,strong)NSString*D_ORDER_TIME;    //要求到达时间
@property(nonatomic,strong)NSString*D_SIGNTIME_TIME;   //签到时间

@property(nonatomic,strong)NSString*X_REMARK;
@property(nonatomic,strong)NSString*X_PICURL;
@property(nonatomic,strong)NSString*B_SIGN_LON;
@property(nonatomic,strong)NSString*B_SIGN_LAT;
@property(nonatomic,strong)NSString*B_CUSTOMER_LON;
@property(nonatomic,strong)NSString*B_CUSTOMER_LAT;
@property(nonatomic,strong)NSString*D_CREATE_TIME;
@property(nonatomic,strong)NSString*X_TASKCONTENT;

@property(nonatomic,strong)NSString*C_LEVEL_DD_ID;
@property(nonatomic,strong)NSString*C_LEVEL_DD_NAME;   //  H类

@property(nonatomic,assign)BOOL isSelected;//重新指派 用的

@property (nonatomic, strong) NSString *C_STAGE_DD_ID;
@property (nonatomic, strong) NSString *C_STAGE_DD_NAME;

@property (nonatomic, strong) NSString *D_LASTFOLLOW_TIME;

/** 预计开始时间*/
@property (nonatomic, strong) NSString *D_START_TIME;
/** D_END_TIME 预计完成时间*/
@property (nonatomic, strong) NSString *D_END_TIME;

/** C_TASKSTATUS_DD_ID 优先等级id*/
@property (nonatomic, strong) NSString *C_TASKSTATUS_DD_ID;
/** C_TASKSTATUS_DD_NAME*/
@property (nonatomic, strong) NSString *C_TASKSTATUS_DD_NAME;
/** ALREADYDAY 已用天数*/
@property (nonatomic, strong) NSString *ALREADYDAY;
/** TIMEOUT 超时时长*/
@property (nonatomic, strong) NSString *TIMEOUT;
/** 当前任务是否超时*/
@property (nonatomic, strong) NSString *TIMEOUTCODE;
@end


//{
//    "C_A41500_C_ID" = "A4150000000122-1475028914e5be2182-c0b8-467b-ad65-799a6f5c6842";
//    "C_A41500_C_NAME" = "\U4e0a\U6d77\U5f3a\U751f\U5317\U7f8e\U6c7d\U8f66\U96ea\U4f5b\U5170";
//    "C_A42000_C_ID" = "";
//    "C_ADDRESS" = "\U4e0a\U6d77\U5e02\U666e\U9640\U533a\U6caa\U592a\U8def800\U53f7";
//    "C_CONTACTPHONE" = 13818848405;
//    "C_HEADIMGURL" = "";
//    "C_ID" = "A0120000000092-15084710943a77adb6-7";
//    "C_OWNER_ROLEID" = 00000094;
//    "C_OWNER_ROLENAME" = "\U5218\U6881\U6881";
//    "C_STATUS_DD_ID" = "A01200_C_STATUS_0001";
//    "C_STATUS_DD_NAME" = "\U786e\U8ba4";
//    "C_TYPE_DD_ID" = "A01200_C_TYPE_0003";
//    "C_TYPE_DD_NAME" = "\U5176\U4ed6";
//    "D_ORDER_TIME" = "2017-10-20 11:44";
//    "D_SIGNTIME_TIME" = "";
//},
