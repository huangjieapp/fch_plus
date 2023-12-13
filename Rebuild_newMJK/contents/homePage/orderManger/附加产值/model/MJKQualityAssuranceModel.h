//
//  MJKQualityAssuranceModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/1.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKQualityAssuranceMainModel : MJKBaseModel
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSArray *content;
@end

@interface MJKQualityAssuranceModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_A42000_C_ID;
@property (nonatomic, strong) NSString *D_CDRQ;
@property (nonatomic, strong) NSString *C_CP;
@property (nonatomic, strong) NSString *C_KH_NAME;
@property (nonatomic, strong) NSString *C_A41500_C_ID;
@property (nonatomic, strong) NSString *C_A41500_C_NAME;
@property (nonatomic, strong) NSString *C_A70600_C_ID;
@property (nonatomic, strong) NSString *C_A70600_C_NAME;
@property (nonatomic, strong) NSString *C_A49600_C_ID;
@property (nonatomic, strong) NSString *C_A49600_C_NAME;
@property (nonatomic, strong) NSString *C_VIN;
@property (nonatomic, strong) NSString *C_ZBXM;
@property (nonatomic, strong) NSString *C_A80000ZB_C_ID;
@property (nonatomic, strong) NSString *C_A80000ZB_C_NAME;
@property (nonatomic, strong) NSString *B_ZBSF;
@property (nonatomic, strong) NSString *I_ISKP;
@property (nonatomic, strong) NSString *C_SKZH;
@property (nonatomic, strong) NSString *B_SFJE;
@property (nonatomic, strong) NSString *D_JSRQ;
@property (nonatomic, strong) NSString *C_JSFS;
@property (nonatomic, strong) NSString *X_REMARK;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_BILLING;

@property (nonatomic, strong) NSString *B_ZBCB;
@property (nonatomic, strong) NSString *B_JLR;
@property (nonatomic, strong) NSString *C_A800JSZH_C_ID;
@property (nonatomic, strong) NSString *C_A800JSZH_C_NAME;
@property (nonatomic, strong) NSString *B_SXGWTC;
@property (nonatomic, strong) NSString *B_JLTC;
@property (nonatomic, strong) NSString *B_DZTC;
/** <#注释#> */
@property (nonatomic, strong) NSString *B_JSJE;
/** <#注释#> */
@property (nonatomic,strong) NSString *C_A800SKZH_C_ID;
@property (nonatomic,strong) NSString *C_A800SKZH_C_NAME;

@property (nonatomic, strong) NSString *C_LOCNAME;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;


@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSString *C_ZBXM_DD_ID;
@property (nonatomic, strong) NSString *C_ZBXM_DD_NAME;
/** <#注释#> */
@property (nonatomic, strong) NSArray *fileListLr;
@property (nonatomic, strong) NSArray *fileListZb;
@end

NS_ASSUME_NONNULL_END
