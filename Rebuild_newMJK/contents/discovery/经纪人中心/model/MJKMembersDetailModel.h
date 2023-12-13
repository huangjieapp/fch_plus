//
//  MJKMembersDetailModel.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/11/30.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKMembersDetailModel : MJKBaseModel
/** <#注释#>*/
@property(nonatomic,strong) NSString *C_ID;
/** 名称*/
@property(nonatomic,strong) NSString *C_NAME;
/** 电话*/
@property(nonatomic,strong) NSString *C_PHONE;
//C_WECHAT
@property(nonatomic,strong) NSString *C_WECHAT;
/** 开户行名称*/
@property(nonatomic,strong) NSString *C_BANKNAME;
/** 开户账号*/
@property(nonatomic,strong) NSString *C_ACCOUNTHOLDER;
/** 税号*/
@property(nonatomic,strong) NSString *C_DUTYPARAGRAPH;
@property(nonatomic,strong) NSString *C_INDUSTRY_DD_ID;
@property(nonatomic,strong) NSString *C_INDUSTRY_DD_NAME;
/** 备注*/
@property(nonatomic,strong) NSString *X_REMARK;
@property(nonatomic,strong) NSString *C_COMPANY;
@property(nonatomic,strong) NSString *C_JSKHS;
@property(nonatomic,strong) NSString *C_INDUSTRY;
@property(nonatomic,strong) NSString *C_ISMC;
/** 类型*/
@property(nonatomic,strong) NSString *C_TYPE_DD_ID;
/** 类型*/
@property(nonatomic,strong) NSString *C_TYPE_DD_NAME;
@property(nonatomic,strong) NSString *C_FSLX_DD_ID;
/** 类型*/
@property(nonatomic,strong) NSString *C_FSLX_DD_NAME;
/** 状态*/
@property(nonatomic,strong) NSString *C_STATUS_DD_ID;
/** 状态*/
@property(nonatomic,strong) NSString *C_STATUS_DD_NAME;
/** 小程序accountid*/
@property(nonatomic,strong) NSString *C_OBJECTID;
/** 地址*/
@property(nonatomic,strong) NSString *C_ENGLISHNAME;
/** 性别*/
@property(nonatomic,strong) NSString *C_SEX_DD_ID;
/** 性别*/
@property(nonatomic,strong) NSString *C_SEX_DD_NAME;
/** 生日*/
@property(nonatomic,strong) NSString *D_BIRTHDAY_TIME;
/** 爱好*/
@property(nonatomic,strong) NSString *C_HOBBY;
/** email*/
@property(nonatomic,strong) NSString *C_EMAIL;
/** 标签id（多个逗号隔开）*/
@property(nonatomic,strong) NSString *X_LABEL;
/** ）*/
@property(nonatomic,strong) NSString *C_LEVEL_DD_ID;
/** */
@property(nonatomic,strong) NSString *C_LEVEL_DD_NAME;
/** */
@property(nonatomic,strong) NSString *C_STAR_DD_ID;

/** */
@property(nonatomic,strong) NSString *C_STAR_DD_NAME;
/** */
@property(nonatomic,strong) NSString *D_CREATE_TIME;
//D_ANNIVERSARY_TIME
@property(nonatomic,strong) NSString *D_ANNIVERSARY_TIME;


/** 备注*/
@property(nonatomic,strong) NSArray *labelsList;
@end
