//
//  MJKInsuranceModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/4.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKInsuranceMainModel : MJKBaseModel

@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSArray *content;
@end

@interface MJKInsuranceModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_LOCNAME;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSString *C_A42000_C_ID;
@property (nonatomic, strong) NSString *D_BXRQ;
@property (nonatomic, strong) NSString *C_KH_NAME;
@property (nonatomic, strong) NSString *C_KH_PHONE;
@property (nonatomic, strong) NSString *C_VIN;
@property (nonatomic, strong) NSString *C_A70600_C_ID;
@property (nonatomic, strong) NSString *C_A70600_C_NAME;
@property (nonatomic, strong) NSString *C_A49600_C_ID;
@property (nonatomic, strong) NSString *C_A49600_C_NAME;
@property (nonatomic, strong) NSString *B_CJ;
@property (nonatomic, strong) NSString *B_KPJ;
@property (nonatomic, strong) NSString *B_JQX;
@property (nonatomic, strong) NSString *B_CSBE;
@property (nonatomic, strong) NSString *B_XZBE;
@property (nonatomic, strong) NSString *B_CCS;
@property (nonatomic, strong) NSString *B_SYX;
@property (nonatomic, strong) NSArray *fileList;
/** <#注释#> */
@property (nonatomic, strong) NSString *X_SFZJYY;


@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;


@property (nonatomic, strong) NSString *C_SFZB_DD_ID;
@property (nonatomic, strong) NSString *C_SFZB_DD_NAME;


@property (nonatomic, strong) NSString *C_SFZJ_DD_ID;
@property (nonatomic, strong) NSString *C_SFZJ_DD_NAME;
@property (nonatomic, strong) NSString *C_XL_DD_ID;
@property (nonatomic, strong) NSString *C_XL_DD_NAME;
@property (nonatomic, strong) NSString *X_BXNR;
@property (nonatomic, strong) NSString *C_BILLING;


@property (nonatomic, strong) NSString *C_CPXZ_DD_ID;
@property (nonatomic, strong) NSString *C_CPXZ_DD_NAME;
@property (nonatomic, strong) NSString *C_DSZ_DD_ID;
@property (nonatomic, strong) NSString *C_DSZ_DD_NAME;
@property (nonatomic, strong) NSString *B_HHX;
@property (nonatomic, strong) NSString *B_XZSBX;
@property (nonatomic, strong) NSString *B_YWZHX;
@property (nonatomic, strong) NSString *C_ZW_DD_ID;
@property (nonatomic, strong) NSString *C_ZW_DD_NAME;
@property (nonatomic, strong) NSString *C_A80000BX_C_ID;
@property (nonatomic, strong) NSString *C_A80000BX_C_NAME;
@property (nonatomic, strong) NSString *C_BXCDY;
@property (nonatomic, strong) NSString *X_REMARK;
@property (nonatomic, strong) NSString *B_ZWX;

@property (nonatomic, strong) NSString *B_SYXFL;
@property (nonatomic, strong) NSString *B_JQXFL;
@property (nonatomic, strong) NSString *B_FJXTC;
@property (nonatomic, strong) NSString *C_JSSTATUS_DD_ID;
@property (nonatomic, strong) NSString *C_JSSTATUS_DD_NAME;
@property (nonatomic, strong) NSString *I_SFCS;
@property (nonatomic, strong) NSString *D_JSRQ;
@property (nonatomic, strong) NSString *B_JSJE;
@property (nonatomic, strong) NSString *C_A800JSZH_C_ID;
@property (nonatomic, strong) NSString *C_A800JSZH_C_NAME;
@property (nonatomic, strong) NSString *B_SXGWTC;
@property (nonatomic, strong) NSString *B_JLTC;
@property (nonatomic, strong) NSString *B_DZTC;
@property (nonatomic, strong) NSString *B_DIANZHUTC;
@property (nonatomic, strong) NSString *X_FJCZREMARK;
@end

NS_ASSUME_NONNULL_END
