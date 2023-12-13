//
//  NewUserSession.h
//  GKAPP
//
//  Created by 黄佳峰 on 15/11/6.
//  Copyright © 2015年 黄佳峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString *C_GRPCODE;
@property (nonatomic, strong) NSString *C_LOCCODE;
@property (nonatomic, strong) NSString *C_LOCNAME;
@property (nonatomic, strong) NSString *C_ORGCODE;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *expireTime;
@property (nonatomic, strong) NSString *groupType;
@property (nonatomic, strong) NSString *loginTime;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *phonenumber;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *u031Id;
@property (nonatomic, strong) NSString *u051Id;
@property (nonatomic, strong) NSString *userId;
/** <#注释#> */
@property (nonatomic, strong) NSString *NEW_C_ORGCODE;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_OPENID;
/** <#注释#> */
@property (nonatomic, strong) NSString *dzqPhone;
/** <#注释#> */
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *C_IDENTITYCODE;
@property (nonatomic, strong) NSString *C_WECHAT;
@property (nonatomic, strong) NSString *C_INTERNAL;
@property (nonatomic, strong) NSString *C_EXTERNAL;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_DESIGNER_ROLEID;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_AZRY_ROLEID;
@end

@interface ConfigData : NSObject
@property (nonatomic, strong) NSString *C_AZRY_ROLEID;
@property (nonatomic, strong) NSString *C_AZRY_ROLENAME;
@property (nonatomic, strong) NSString *C_BILLINGID;
@property (nonatomic, strong) NSString *C_BILLINGNAME;
@property (nonatomic, strong) NSString *C_DESIGNER_ROLEID;
@property (nonatomic, strong) NSString *C_DESIGNER_ROLENAME;
@property (nonatomic, strong) NSString *C_KHPX;
@property (nonatomic, strong) NSString *C_LYSZ;
@property (nonatomic, strong) NSString *C_WLCCRY_ROLEID;
@property (nonatomic, strong) NSString *C_WLCCRY_ROLENAME;
@property (nonatomic, strong) NSString *IS_DDJF;
@property (nonatomic, strong) NSString *IS_DDJG;
@property (nonatomic, strong) NSString *IS_DDQX;
@property (nonatomic, strong) NSString *IS_JSRSFKFXZ;
@property (nonatomic, strong) NSString *IS_KHXQDZ;
@property (nonatomic, strong) NSString *IS_QKJH;
@property (nonatomic, strong) NSString *IS_QKZB;
@property (nonatomic, strong) NSString *IS_QKZC;
@property (nonatomic, strong) NSString *IS_RWPB;
@property (nonatomic, strong) NSString *IS_TELEPHONEPRIVACY;
@property (nonatomic, strong) NSMutableArray *app_base;
@property (nonatomic, strong) NSMutableArray *app_default;
@property (nonatomic, strong) NSMutableArray *app_jp;
@property (nonatomic, strong) NSMutableArray *app_mjk;
@property (nonatomic, strong) NSMutableArray *app_mzg;
@property (nonatomic, strong) NSMutableArray *app_report;
@property (nonatomic, strong) NSMutableArray *btListDd;
@property (nonatomic, strong) NSMutableArray *btListMapKh;
@property (nonatomic, strong) NSMutableArray *btListMapRb;
@property (nonatomic, strong) NSMutableArray *cpsrList;
@property (nonatomic, strong) NSMutableArray *ddxxkfxzseList;
@property (nonatomic, strong) NSArray *khtsList;
/** <#注释#> */
@property (nonatomic, strong) NSArray *requiredCode;
/** <#注释#> */
@property (nonatomic, assign) BOOL setThPush;
@property (nonatomic, strong) NSString *ruiwei_password;
@property (nonatomic, strong) NSString *ruiwei_phoneNo;
@property (nonatomic, strong) NSArray *sybbxsszList;
@end

@interface NewUserSession : NSObject
/** <#注释#>*/

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) ConfigData *configData;
@property (nonatomic, strong) NSArray *appcode;
@property (nonatomic, strong) NSArray *storecode;
/** <#注释#> */
@property (nonatomic, strong) NSString *TOKEN;
/** <#注释#> */
@property (nonatomic, strong) NSString *jobStr;
/** <#注释#> */
@property (nonatomic, strong) NSArray *datadict;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_ISSSDDBH_DD_ID;
/** <#注释#>*/
@property (nonatomic, assign) BOOL isApp_jp;
/** <#注释#> */
@property (nonatomic, strong) NSString *accountId;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_GID;
/** <#注释#> */
@property (nonatomic, strong) NSString *I_MP_SQ;
/** <#注释#>*/
@property (nonatomic, assign) BOOL isLogin;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_APPID;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_APPSECRET;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_FORWARD;
@property (nonatomic, strong) NSString *C_INTERNAL;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_APPTYPE_DD_ID;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_XCXPOSITION;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_ABBREVATION;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *sybbxsszList;
/** <#注释#> */
@property (nonatomic, strong) NSString *D_LASTUPDATE_TIME;
/** <#注释#> */
@property (nonatomic, strong) NSString *storeAddress;
/** <#注释#> */
@property (nonatomic, strong) NSString *BusinessCardPicture;
/** <#注释#> */
@property (nonatomic, strong) NSString *X_WHY;
/** <#注释#> */
@property (nonatomic, strong) NSString *I_MP;
@property (nonatomic, strong) NSString *I_RMCP_SQ;
@property (nonatomic, strong) NSString *I_JXKL_SQ;
@property (nonatomic, strong) NSString *I_ZXHD_SQ;
/** <#注释#> */
@property (nonatomic, strong) NSArray *hotappList;

//登录 之后赋值
+ (void)saveUserInfoWithDic:(NSDictionary *)dataDic;
+ (NewUserSession *) instance;   //单例
+ (void)cleanUser;     //清空





@end



























