//
//  MJKOldCustomerSalesModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/11/4.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKOldCustomerSalesMainModel : MJKBaseModel
/** <#注释#> */
@property (nonatomic, strong) NSArray *content;
/** <#注释#> */
@property (nonatomic, strong) NSString *total;
@end

@interface MJKOldCustomerSalesModel : NSObject
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_OWNER_ROLEID;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSString *C_XSGW_ROLEID;
@property (nonatomic, strong) NSString *C_XSGW_ROLENAME;
@property (nonatomic, strong) NSString *C_KH_NAME_TEM;
@property (nonatomic, strong) NSString *C_KH_PHONE_TEM;
@property (nonatomic, strong) NSString *C_KH_NAME;
@property (nonatomic, strong) NSString *C_KH_PHONE;
@property (nonatomic, strong) NSString *C_A47700_C_ID;
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
@property (nonatomic, strong) NSString *C_JJCD_DD_ID;
@property (nonatomic, strong) NSString *C_JJCD_DD_NAME;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_A80000CJ_C_ID;
@property (nonatomic, strong) NSString *C_A80000CJ_C_NAME;
@property (nonatomic, strong) NSString *C_A70600_C_ID;
@property (nonatomic, strong) NSString *C_A70600_C_NAME;
@property (nonatomic, strong) NSString *C_A49600_C_ID;
@property (nonatomic, strong) NSString *C_A49600_C_NAME;
@property (nonatomic, strong) NSString *C_JTXH;
@property (nonatomic, strong) NSString *C_VIN;
@property (nonatomic, strong) NSString *D_BXRQ;
@property (nonatomic, strong) NSString *D_JCRQ;
@property (nonatomic, strong) NSString *C_CLSZD;
@property (nonatomic, strong) NSString *C_SHWTD;
@property (nonatomic, strong) NSString *C_BXWTMS;
@property (nonatomic, strong) NSString *I_SFGB;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSString *C_WXRYTYPE_DD_ID;
@property (nonatomic, strong) NSString *C_WXRYTYPE_DD_NAME;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_A42000_C_ID;
@property (nonatomic, strong) NSString *C_A42000_C_NAME;


@property (nonatomic, strong) NSArray *fileListGzImage;
@property (nonatomic, strong) NSArray *fileListGzVideo;
@property (nonatomic, strong) NSArray *fileListGlsImage;
@property (nonatomic, strong) NSArray *fileListXszImage;
@property (nonatomic, strong) NSArray *shwtdArray;

@property (nonatomic, strong) NSString *C_WXRY_ROLEID;
@property (nonatomic, strong) NSString *C_WXRY_ROLENAME;
@property (nonatomic, strong) NSString *I_SFCSFY;

@property (nonatomic, strong) NSString *C_WXFA;
@property (nonatomic, strong) NSString *X_KHYJ;
@property (nonatomic, strong) NSString *C_WWXYY_DD_ID;
@property (nonatomic, strong) NSString *C_WWXYY_DD_NAME;
@property (nonatomic, strong) NSString *D_FINISH_TIME;
@property (nonatomic, strong) NSString *D_WXSJ;
@end

NS_ASSUME_NONNULL_END
