//
//  MJKCarSourceHomeModel.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/19.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJKBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MJKCarSourceHomeModel : MJKBaseModel
/** <#注释#> */
@property (nonatomic, strong) NSArray *content;
/** <#注释#> */
@property (nonatomic, strong) NSString *total;
@end


@interface MJKCarSourceHomeSubModel : MJKBaseModel
@property (nonatomic, strong) NSString *B_GLS;
@property (nonatomic, strong) NSString *C_A49600_C_ID;
@property (nonatomic, strong) NSString *C_A49600_C_NAME;
@property (nonatomic, strong) NSString *C_A70600_C_ID;
@property (nonatomic, strong) NSString *C_A70600_C_NAME;
@property (nonatomic, strong) NSString *C_A80000CJ_C_ID;
@property (nonatomic, strong) NSString *C_A80000CJ_C_NAME;
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
@property (nonatomic, strong) NSString *C_A80000SZD_C_ID;
@property (nonatomic, strong) NSString *C_A80000SZD_C_NAME;
@property (nonatomic, strong) NSString *C_ADDRESS;
@property (nonatomic, strong) NSString *C_ADDITIONAL_PRODUCTS;
@property (nonatomic, strong) NSString *C_CAR_TYPE;
@property (nonatomic, strong) NSString *C_ENVIRONMENTAL_PROTECTION;
@property (nonatomic, strong) NSString *C_FILE_CITY;
@property (nonatomic, strong) NSString *C_GHCDPQD;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_INFORM_THE_SINGLE;
@property (nonatomic, strong) NSString *C_MINI_TRANSFER;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_N_COLOR;
@property (nonatomic, strong) NSString *C_ORIGINAL_LOCATION;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSString *C_VIN;
@property (nonatomic, strong) NSString *C_VOUCHERID;
@property (nonatomic, strong) NSString *C_W_COLOR;
@property (nonatomic, strong) NSString *C_YS;
@property (nonatomic, strong) NSString *D_ARRIVAL_TIME;
@property (nonatomic, strong) NSString *D_CHASSIS_TIME;
@property (nonatomic, strong) NSString *D_MODIFIED_TIME;
@property (nonatomic, strong) NSString *I_SEAT;
@property (nonatomic, strong) NSString *X_REMARK;
@property (nonatomic, strong) NSString *C_LOCCODE;
@property (nonatomic, strong) NSString *C_LOCNAME;
@property (nonatomic, strong) NSArray *fileListFp;
@property (nonatomic, strong) NSArray *fileListYs;

@end


@interface MJKCarSourceLockModel : MJKBaseModel

@property (nonatomic, strong) NSString *C_A42000_C_ID;
@property (nonatomic, strong) NSString *C_A82300_C_ID;
@property (nonatomic, strong) NSString *C_CYSTATUS_DD_ID;
@property (nonatomic, strong) NSString *C_CYSTATUS_DD_NAME;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSString *D_CREATE_TIME;
@property (nonatomic, strong) NSString *C_CREATOR_ROLENAME;
@end

@interface MJKCarSourceWLModel : MJKBaseModel

@property (nonatomic, strong) NSString *B_YF;
@property (nonatomic, strong) NSString *C_A80000DCF_C_ID;
@property (nonatomic, strong) NSString *C_A80000DCF_C_NAME;
@property (nonatomic, strong) NSString *C_A80000DRF_C_ID;
@property (nonatomic, strong) NSString *C_A80000DRF_C_NAME;
@property (nonatomic, strong) NSString *C_A82300_C_ID;
@property (nonatomic, strong) NSString *C_ADDRESS;
@property (nonatomic, strong) NSString *C_BCSJ;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_PHONE;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
@property (nonatomic, strong) NSString *C_WLGS;
@property (nonatomic, strong) NSString *C_YY_DD_ID;
@property (nonatomic, strong) NSString *C_YY_DD_NAME;
@property (nonatomic, strong) NSString *I_SFCDSBYF;
@property (nonatomic, strong) NSString *I_SFTY;
@property (nonatomic, strong) NSArray *fileList;
@property (nonatomic, strong) NSString *X_REMARK;
@property (nonatomic, strong) NSString *D_CREATE_TIME;
@property (nonatomic, strong) NSString *C_CREATOR_ROLENAME;
@end

@interface MJKCarSourceGJModel : MJKBaseModel

@property (nonatomic, strong) NSString *C_CREATOR_ROLEID;
@property (nonatomic, strong) NSString *C_CREATOR_ROLENAME;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *D_CREATE_TIME;
@property (nonatomic, strong) NSString *X_REMARK;
@property (nonatomic, strong) NSString *dateType;
@end

NS_ASSUME_NONNULL_END
