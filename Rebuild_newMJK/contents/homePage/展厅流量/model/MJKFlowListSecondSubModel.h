//
//  MJKFlowListSecondSubModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/7.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKFlowListSecondSubModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_A40600_C_ID;

@property (nonatomic, strong) NSString *C_A40600_C_NAME;

@property (nonatomic, strong) NSString *C_A41200_C_ID;

@property (nonatomic, strong) NSString *C_A41200_C_NAME;
/** <#注释#> */
@property (nonatomic, strong) NSString *I_PEPOLE_NUMBER;
/** C_SOURCE_DD_NAME*/
@property (nonatomic, strong) NSString *C_SOURCE_DD_NAME;
/** C_SOURCE_DD_ID*/
@property (nonatomic, strong) NSString *C_SOURCE_DD_ID;

@property (nonatomic, strong) NSString *C_A41500_C_ID;

@property (nonatomic, strong) NSString *C_A41500_C_NAME;

@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_ID;

@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_NAME;

@property (nonatomic, strong) NSString *C_COMPOSE;

@property (nonatomic, strong) NSString *C_HEADIMGURL;

@property (nonatomic, strong) NSString *C_ID;

@property (nonatomic, strong) NSString *C_LEVEL_C_ID;

@property (nonatomic, strong) NSString *C_LEVEL_C_NAME;

@property (nonatomic, strong) NSString *C_OWNER_ROLEID;

@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;

@property (nonatomic, strong) NSString *C_PHONE;

@property (nonatomic, strong) NSString *C_PICURL;

@property (nonatomic, strong) NSString *C_STAGE_C_ID;

@property (nonatomic, strong) NSString *C_STAGE_C_NAME;

@property (nonatomic, strong) NSString *C_STATUS_DD_ID;

@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;

@property (nonatomic, strong) NSString *D_ARRIVAL_TIME;

@property (nonatomic, strong) NSString *D_LEAVE_TIME;

@property (nonatomic, strong) NSString *FLAG;

//未留档原因
@property (nonatomic, strong) NSString *C_REMARK_TYPE_DD_ID;

@property(nonatomic,copy) NSString * C_LEVEL_DD_ID;
@property(nonatomic,copy) NSString * C_LEVEL_DD_NAME;
@property(nonatomic,copy) NSString * C_STAGE_DD_NAME;
@property(nonatomic,copy) NSString * C_STAGE_DD_ID;
@property(nonatomic,copy) NSString * D_LASTFOLLOW_TIME;

@property (nonatomic, getter=isSelected) BOOL selected;
@end
