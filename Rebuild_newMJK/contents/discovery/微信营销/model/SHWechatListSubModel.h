//
//  SHWechatListSubModel.h
//  mcr_sh_master
//
//  Created by Hjie on 2017/8/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHWechatListSubModel : MJKBaseModel

//1.粉丝ID
@property (nonatomic, strong) NSString *C_ID;
//2.粉丝名称
@property (nonatomic, strong) NSString *C_NAME;
//3.粉丝头像
@property (nonatomic, strong) NSString *C_HEADIMGURL;
//4.性别ID
@property (nonatomic, strong) NSString *C_GENDER_DD_ID;
//5.性别
@property (nonatomic, strong) NSString *C_GENDER_DD_NAME;
//6.类型ID
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
//7.类型
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
//8.状态ID
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
//9.状态
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
//10.最后活跃时间
@property (nonatomic, strong) NSString *D_LASTUPDATE_TIME;
//11.销售顾问ID
@property (nonatomic, strong) NSString *C_OWNER_ROLEID;
//12.销售顾问
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
//13.创建时间
@property (nonatomic, strong) NSString *D_CREATE_TIME;
//14.所在城市
@property (nonatomic, strong) NSString *C_CITYNAME;
//15.扫码渠道
@property (nonatomic, strong) NSString *C_CHANNEL_DD_NAME;
//16.首次关注时间
@property (nonatomic, strong) NSString *D_CONVERT_TIME;
//17.潜客ID
@property (nonatomic, strong) NSString *C_A41500_C_ID;
//18.潜客
@property (nonatomic, strong) NSString *C_A41500_C_NAME;
//19.潜客电话
@property (nonatomic, strong) NSString *C_PHONE;
//20.处理状态 0未处理 1已处理
@property (nonatomic, strong) NSString *C_CLZT;
//21.星标状态 0否 1是
@property (nonatomic, strong) NSString *C_STAR;
//22.粉丝备注
@property (nonatomic, strong) NSString *X_REMARK;
//23.0不是协助粉丝 1是协助粉丝
@property (nonatomic, strong) NSString *ASSIST;

@end
