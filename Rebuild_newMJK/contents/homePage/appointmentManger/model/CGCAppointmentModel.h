//
//  CGCAppointmentModel.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGCAppointmentModel : MJKBaseModel

//
@property(nonatomic,strong) NSString * C_A40600_C_ID;
///
@property(nonatomic,strong) NSString * C_A40600_C_NAME;
///潜客ID
@property(nonatomic,copy) NSString * C_A41500_C_ID;
///姓名
@property(nonatomic,copy) NSString * C_A41500_C_NAME;
///
@property(nonatomic,copy) NSString * C_COMPOSE;
///
@property(nonatomic,copy) NSString * C_DEALFLAG;
///
@property(nonatomic,copy) NSString * C_HEADIMGURL;
///
@property(nonatomic,copy) NSString * C_ID;
///
@property(nonatomic,copy) NSString * C_IS_RESERVATION_DD_ID;
///电话
@property(nonatomic,copy) NSString * C_IS_RESERVATION_DD_NAME;
///性别ID
@property(nonatomic,copy) NSString * C_PHONE;
///性别
@property(nonatomic,copy) NSString * C_SEX_DD_ID;
///预约时间
@property(nonatomic,copy) NSString * C_SEX_DD_NAME;
@property(nonatomic,copy) NSString *C_YS_DD_ID;
@property(nonatomic,copy) NSString *C_YS_DD_NAME;
@property(nonatomic,copy) NSString *C_PAYMENT_DD_ID;
@property(nonatomic,copy) NSString *C_PAYMENT_DD_NAME;
@property(nonatomic,copy) NSString *C_CLUESOURCE_DD_ID;
@property(nonatomic,copy) NSString *C_CLUESOURCE_DD_NAME;
@property(nonatomic,copy) NSString *C_A41200_C_ID;
@property(nonatomic,copy) NSString *C_A41200_C_NAME;
///到店状态
@property(nonatomic,copy) NSString * C_STATUS_DD_ID;
///
@property(nonatomic,copy) NSString * C_STATUS_DD_NAME;
///
@property(nonatomic,copy) NSString * D_BOOK_TIME;
@property(nonatomic,copy) NSString *C_MODEFOLLOW_DD_ID;
@property(nonatomic,copy) NSString *C_MODEFOLLOW_DD_NAME;
@property(nonatomic,copy) NSString *C_ISDRIVE_DD_ID;
@property(nonatomic,copy) NSString *C_ISDRIVE_DD_NAME;
///
@property(nonatomic,copy) NSString * D_CREATE_TIME;
@property(nonatomic,copy) NSString *D_ARRIVE_TIME;
///
@property(nonatomic,copy) NSString * IS_ARRIVE_SHOP;
///
@property(nonatomic,copy) NSString * USER_ID;
///
@property(nonatomic,copy) NSString * USER_NAME;
///
@property(nonatomic,copy) NSString * message;
///
@property(nonatomic,copy) NSString * X_REMARK;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_STAYTIME_DD_ID;
@property (nonatomic, strong) NSString *C_STAYTIME_DD_NAME;

///
@property(nonatomic,copy) NSString * C_OWNER_ROLEID;
///
@property(nonatomic,copy) NSString * C_OWNER_ROLENAME;

@property(nonatomic,copy) NSString * C_LEVEL_DD_ID;
@property(nonatomic,copy) NSString * C_LEVEL_DD_NAME;
@property(nonatomic,copy) NSString * C_STAGE_DD_NAME;
@property(nonatomic,copy) NSString * C_STAGE_DD_ID;
@property(nonatomic,copy) NSString * D_LASTFOLLOW_TIME;

@end
