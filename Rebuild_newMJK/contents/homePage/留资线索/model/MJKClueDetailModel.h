//
//  MJKClueDetailModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKClueDetailModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
@property (nonatomic, strong) NSString *C_A40600_C_ID;
//意向车型
@property (nonatomic, strong) NSString *C_A40600_C_NAME;
@property (nonatomic, strong) NSString *C_A41200_C_ID;
//市场活动
@property (nonatomic, strong) NSString *C_A41200_C_NAME;
@property (nonatomic, strong) NSString *C_A41500_C_ID;
@property (nonatomic, strong) NSString *C_A41900_C_ID;
@property (nonatomic, strong) NSString *C_A41900_C_NAME;
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_ID;
//线索来源
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_NAME;
//线索ID
@property (nonatomic, strong) NSString *C_ID;
//客户姓名
@property (nonatomic, strong) NSString *C_NAME;
//手机号
@property (nonatomic, strong) NSString *C_PHONE;
@property (nonatomic, strong) NSString *C_PURPOSE;
@property (nonatomic, strong) NSString *C_SEX_DD_ID;
//性别
@property (nonatomic, strong) NSString *C_SEX_DD_NAME;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
//线索下发时间
@property (nonatomic, strong) NSString *D_LEAD_TIME;
//客户登记时间
@property (nonatomic, strong) NSString *D_SHOP_TIME;
//备注
@property (nonatomic, strong) NSString *X_REMARK;

@property (nonatomic, strong) NSString *C_WECHAT;
@property (nonatomic, strong) NSString *C_ADDRESS;
/** 所属人*/
@property (nonatomic, strong) NSString *C_CLUEPROVIDER_ROLEID;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
/** 创建人*/
@property (nonatomic, strong) NSString *C_CREATOR_ROLENNAME;
//C_A47700_C_ID
@property (nonatomic, strong) NSString *C_A47700_C_ID;
@property (nonatomic, strong) NSString *C_A47700_C_NAME;

//@property (nonatomic, strong) NSString *C_CLUEPROVIDER_ROLEID;
@property (nonatomic, strong) NSString *C_CLUEPROVIDER_ROLENAME;
/** <#注释#>*/
@property (nonatomic, strong) NSString *intentionDesc;
@property (nonatomic, strong) NSString *C_ENGLISHNAME;

/** 楼盘id*/
@property (nonatomic, strong) NSString *C_A48200_C_ID;
/** 楼盘*/
@property (nonatomic, strong) NSString *C_A48200_C_NAME;

//C_SOURCEOWNERNAME
@property (nonatomic, strong) NSString *C_SOURCEOWNERID;
@property (nonatomic, strong) NSString *C_SOURCEOWNERNAME;
@property (nonatomic, strong) NSString *D_NEXTCONTACT_TIME;

+ (NSArray *)arrayWithModel:(MJKClueDetailModel *)model;
@end
