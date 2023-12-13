//
//  MJKRegistrationModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/2.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKRegistrationModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_LOCNAME;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSString *C_A42000_C_ID;
@property (nonatomic, strong) NSString *D_SQRQ;
@property (nonatomic, strong) NSString *C_A70600_C_ID;
@property (nonatomic, strong) NSString *C_A70600_C_NAME;
@property (nonatomic, strong) NSString *C_A49600_C_ID;
@property (nonatomic, strong) NSString *C_A49600_C_NAME;
@property (nonatomic, strong) NSString *C_A80000CJ_C_ID;
@property (nonatomic, strong) NSString *C_A80000CJ_C_NAME;
@property (nonatomic, strong) NSString *C_JTXH;
@property (nonatomic, strong) NSString *C_VIN;
@property (nonatomic, strong) NSString *C_TC;
@property (nonatomic, strong) NSString *D_SEND_TIME;
@property (nonatomic, strong) NSString *D_SSPFRQ;
@property (nonatomic, strong) NSString *B_SSPFJE;
@property (nonatomic, strong) NSString *D_YJSPSJ;
@property (nonatomic, strong) NSString *C_PROVINCE_ID;
@property (nonatomic, strong) NSString *C_PROVINCE_NAME;
@property (nonatomic, strong) NSString *C_CITY_ID;
@property (nonatomic, strong) NSString *C_CITY_NAME;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_BILLING;
@property (nonatomic, strong) NSString *C_SPCLX_DD_ID;
@property (nonatomic, strong) NSString *C_SPCLX_DD_NAME;
@property (nonatomic, strong) NSString *C_SPLHYXM_ROLEID;
@property (nonatomic, strong) NSString *C_SPLHYXM_ROLENAME;
@property (nonatomic, strong) NSString *C_CLZT_DD_ID;
@property (nonatomic, strong) NSString *C_CLZT_DD_NAME;
@property (nonatomic, strong) NSString *C_TDRXM;
@property (nonatomic, strong) NSString *C_KH_NAME;
@property (nonatomic, strong) NSString *C_KH_PHONE;
@property (nonatomic, strong) NSString *B_CWHSSPFJE;
@property (nonatomic, strong) NSString *X_REMARK;
@property (nonatomic, strong) NSString *C_SPZT_DD_ID;


@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSArray *fileListDjzs;
@property (nonatomic, strong) NSArray *fileListXsz;

@property (nonatomic, strong) NSString *D_SPRQ;
@property (nonatomic, strong) NSString *B_SPHNF;
@property (nonatomic, strong) NSString *B_SPGBF;
@property (nonatomic, strong) NSString *B_CLF;
@property (nonatomic, strong) NSString *B_BWCZF;
@property (nonatomic, strong) NSString *B_WLF;
@property (nonatomic, strong) NSString *B_CLTYF;
@property (nonatomic, strong) NSString *B_SCGYYF;
@property (nonatomic, strong) NSString *B_QTFY;
@property (nonatomic, strong) NSString *B_FYHJ;
@property (nonatomic, strong) NSString *B_SYLR;
@property (nonatomic, strong) NSString *C_HN_NAME;
@property (nonatomic, strong) NSString *C_HN_PHONE;
@property (nonatomic, strong) NSString *B_SXGWTC;
@property (nonatomic, strong) NSString *B_JLTC;
@property (nonatomic, strong) NSString *B_DZTC;

@end

NS_ASSUME_NONNULL_END
