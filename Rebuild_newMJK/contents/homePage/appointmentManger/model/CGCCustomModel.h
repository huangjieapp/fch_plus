//
//  CGCCustomModel.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/1.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGCCustomModel : MJKBaseModel


@property(nonatomic,copy) NSString * C_A41200_C_ID;

@property(nonatomic,copy) NSString * C_A41200_C_NAME;
@property(nonatomic,copy) NSString *C_FSLX_DD_ID;
@property(nonatomic,copy) NSString *C_FSLX_DD_NAME;

@property(nonatomic,copy) NSString * C_A41500_C_ID;

@property(nonatomic,copy) NSString * C_A41900_C_ID;

@property(nonatomic,copy) NSString * C_A41900_C_NAME;

@property(nonatomic,copy) NSString * C_CLUESOURCE_DD_ID;

@property(nonatomic,copy) NSString * C_CLUESOURCE_DD_NAME;

@property(nonatomic,copy) NSString * C_COMPOSE;

@property(nonatomic,copy) NSString * C_ID;

@property(nonatomic,copy) NSString * C_NAME;

@property(nonatomic,copy) NSString * C_OWNER_ROLENAME;

@property(nonatomic,copy) NSString * C_PHONE;

@property(nonatomic,copy) NSString * C_PICURL;

@property(nonatomic,copy) NSString * C_SEX_DD_ID;

@property(nonatomic,copy) NSString * C_SEX_DD_NAME;

@property(nonatomic,copy) NSString * C_STATUS_DD_ID;

@property(nonatomic,copy) NSString * C_STATUS_DD_NAME;

@property(nonatomic,copy) NSString * D_SHOP_TIME;

@property(nonatomic,copy) NSString * C_LEVEL_DD_ID;

@property(nonatomic,copy) NSString * C_LEVEL_DD_NAME;

@property(nonatomic,copy) NSString * C_STAR_DD_ID;

@property(nonatomic,copy) NSString * C_STAR_DD_NAME;
@property(nonatomic,copy) NSString * SR;

@property(nonatomic,copy) NSString * C_ADDRESS;
@property(nonatomic,copy) NSString * C_DESIGNER_ROLEID;

@property(nonatomic,copy) NSString * C_DESIGNER_ROLENAME;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_CLUEPROVIDER_ROLEID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_CLUEPROVIDER_ROLENAME;
@property (nonatomic, strong) NSString *C_ENGLISHNAME;
//C_CREATOR_ROLENAME
@property (nonatomic, strong) NSString *C_CREATOR_ROLEID;
@property (nonatomic, strong) NSString *C_CREATOR_ROLENAME;
/** 手动输入的产品*/
@property (nonatomic, strong) NSString *X_INTENTIONREMARK;
//C_HEADIMGURL
@property (nonatomic, strong) NSString *C_HEADIMGURL;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_HEADIMGURL_SHOW;

@property(assign) BOOL checked;


@property(assign) BOOL isSelChecked;

@property(nonatomic,copy) NSString * C_OBJECTID;

@property(nonatomic,copy) NSString * I_INTEGRAL;

@property(nonatomic,copy) NSString * C_TYPE_DD_NAME;
@property(nonatomic,copy) NSString * C_TYPE_DD_ID;
@property(nonatomic,copy) NSString * C_USER_ID;

@property(nonatomic,copy) NSString * C_WECHAT;

@property(nonatomic,copy) NSString * C_OPENID;

@property(nonatomic,copy) NSString * count;

/** <#注释#>*/
@property (nonatomic, strong) NSString *C_A48200_C_NAME;
@property (nonatomic, strong) NSString *C_A48200_C_ID;
@property(nonatomic,strong) NSString *C_YX_A70600_C_ID;
@property(nonatomic,strong) NSString *C_YX_A70600_C_NAME;
@property(nonatomic,strong) NSString *C_YX_A49600_C_ID;
@property(nonatomic,strong) NSString *C_YX_A49600_C_NAME;
@property(nonatomic,strong) NSString *C_YX_A49600_C_PICTURE;


@property(nonatomic,strong) NSString *C_A49600_C_ID;
@property(nonatomic,strong) NSString *C_A49600_C_NAME;
@property(nonatomic,strong) NSString *C_A70600_C_ID;
@property(nonatomic,strong) NSString *C_A70600_C_NAME;

@end
