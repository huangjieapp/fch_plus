//
//  MJKFlowDetailModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/11.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKFlowDetailModel : MJKBaseModel

@property (nonatomic, strong) NSString *C_A41200_C_ID;
@property (nonatomic, strong) NSString *C_A41200_C_NAME;
@property (nonatomic, strong) NSString *C_AGE;
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_ID;
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_NAME;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_PHONE;
@property (nonatomic, strong) NSString *C_REMARK_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_REMARK_TYPE_DD_NAME;
@property (nonatomic, strong) NSString *C_SEX;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSString *D_ARRIVAL_TIME;
@property (nonatomic, strong) NSString *I_PEPOLE_NUMBER;
@property (nonatomic, strong) NSString *X_REMARK;
@property (nonatomic, strong) NSArray *headpic_content;  //[0]  C_HEADPIC    C_A46000_C_ID   C_AGE   C_SEX  值
@property (nonatomic, strong) NSString *headpic_count;
@property (nonatomic, strong) NSString *C_SOURCE_DD_NAME;
@property (nonatomic, strong) NSString *C_SOURCE_DD_ID;
/** C_ATTENDANT 随行人员*/
@property (nonatomic, strong) NSString *C_ATTENDANT;
/** 逗留时间*/
@property (nonatomic, strong) NSString *C_STAYTIME_DD_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_STAYTIME_DD_NAME;
@end
