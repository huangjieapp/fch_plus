//
//  MJKEmployeesAccountModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2018/12/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKEmployeesAccountModel : MJKBaseModel
/** 账号*/
@property (nonatomic, strong) NSString *C_ACCOUNTNAME;
/** 地址*/
@property (nonatomic, strong) NSString *C_ADDRESS;
/** 创建人*/
@property (nonatomic, strong) NSString *C_CREATOR_ROLENAME;
/** 教育程度*/
@property (nonatomic, strong) NSString *C_EDUCATION;
/** 传真*/
@property (nonatomic, strong) NSString *C_FAXNUMBER;
/** 性别*/
@property (nonatomic, strong) NSString *C_GENDER_DD_ID;
/** 性别*/
@property (nonatomic, strong) NSString *C_GENDER_DD_NAME;
/** 头像*/
@property (nonatomic, strong) NSString *C_HEADIMGURL;
/** userid*/
@property (nonatomic, strong) NSString *C_ID;
/** 身份证号码*/
@property (nonatomic, strong) NSString *C_IDENTITYCODE;
/** 修改人*/
@property (nonatomic, strong) NSString *C_MENDER_ROLENAME;
/** 手机号*/
@property (nonatomic, strong) NSString *C_MOBILENUMBER;
/** C_NAME*/
@property (nonatomic, strong) NSString *C_NAME;
/** 籍贯*/
@property (nonatomic, strong) NSString *C_NATIVEPLACE;
/** 电话*/
@property (nonatomic, strong) NSString *C_PHONENUMBER;
/** 职位*/
@property (nonatomic, strong) NSString *C_POSITION;
/** 组织架构id*/
@property (nonatomic, strong) NSString *C_U00100_C_ID;
/** 组织架构*/
@property (nonatomic, strong) NSString *C_U00100_C_NAME;
/** 岗位id*/
@property (nonatomic, strong) NSString *C_U00300_C_ID;
/** 岗位*/
@property (nonatomic, strong) NSString *C_U00300_C_NAME;
/** 汇报上级id*/
@property (nonatomic, strong) NSString *C_U03100_C_ID;
/** 汇报上级*/
@property (nonatomic, strong) NSString *C_U03100_C_NAME;
/** 微信*/
@property (nonatomic, strong) NSString *C_WECHAT;
/** 生日*/
@property (nonatomic, strong) NSString *D_BIRTHDAY;
/** 创建时间*/
@property (nonatomic, strong) NSString *D_CREATE_TIME;
/** 离职日期*/
@property (nonatomic, strong) NSString *D_DIMISSIONTIME;
/** 修改时间*/
@property (nonatomic, strong) NSString *D_LASTUPDATE_TIME;
/** 入职时间*/
@property (nonatomic, strong) NSString *D_WORKTIME;
/** 离职原因*/
@property (nonatomic, strong) NSString *X_DIMISSIONREASON;
/** 备注*/
@property (nonatomic, strong) NSString *X_REMARK;
/** <#注释#>*/
@property (nonatomic, strong) NSString *objectCountRemark;

/** 帐号下业务数据全为0返回false，
 有一项不为0返回true*/
@property (nonatomic, strong) NSString *objectCountRemark_flag;
@end

NS_ASSUME_NONNULL_END
