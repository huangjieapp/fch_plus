//
//  MJKClueListMainSecondModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKClueListMainSecondModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_A41200_C_ID;
@property (nonatomic, strong) NSString *C_A41200_C_NAME;
@property (nonatomic, strong) NSString *C_A41500_C_ID;
@property (nonatomic, strong) NSString *C_A41900_C_ID;
@property (nonatomic, strong) NSString *C_A41900_C_NAME;
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_ID;
/** <#注释#> */
@property (nonatomic, strong) NSString *IS_FOLLOW;
//线索来源
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_NAME;
@property (nonatomic, strong) NSString *C_COMPOSE;
//线索id
@property (nonatomic, strong) NSString *C_ID;
//客户姓名
@property (nonatomic, strong) NSString *C_NAME;
//销售顾问
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSString *C_PHONE;
@property (nonatomic, strong) NSString *C_PICURL;
@property (nonatomic, strong) NSString *C_SEX_DD_ID;
@property (nonatomic, strong) NSString *C_SEX_DD_NAME;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
//线索状态
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
//登记时间
@property (nonatomic, strong) NSString *D_SHOP_TIME;
@property (nonatomic, strong) NSString *checked;

@property (nonatomic, strong) NSString *C_WECHAT;

//关闭原因
@property (nonatomic, strong) NSString *C_REMARK_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_PURPOSE;//意向车型

@property(nonatomic,copy) NSString * C_LEVEL_DD_ID;
@property(nonatomic,copy) NSString * C_LEVEL_DD_NAME;
@property(nonatomic,copy) NSString * C_STAGE_DD_NAME;
@property(nonatomic,copy) NSString * C_STAGE_DD_ID;
@property(nonatomic,copy) NSString * D_LASTFOLLOW_TIME;
@property(nonatomic,copy) NSString * X_REMARK;
@property(nonatomic,copy) NSString * C_CUSTOMERSTATUS_DD_ID;
@property(nonatomic,copy) NSString * C_CUSTOMERSTATUS_DD_NAME;
@property(nonatomic,copy) NSString *C_REGION;

@property (nonatomic,getter=isSelected) BOOL selected;


@end
