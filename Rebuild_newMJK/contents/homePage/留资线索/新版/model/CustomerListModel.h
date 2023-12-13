//
//  CustomerListModel.h
//  match
//
//  Created by huangjie on 2022/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerListSubModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *C_A41500_C_ID;
@property (nonatomic, strong) NSString *C_A41200_C_ID;
@property (nonatomic, strong) NSString *C_A41200_C_NAME;
@property (nonatomic, strong) NSString *C_A47700_C_ID;
@property (nonatomic, strong) NSString *C_A47700_C_NAME;
@property (nonatomic, strong) NSString *C_A49600_C_ID;
@property (nonatomic, strong) NSString *C_A49600_C_NAME;
@property (nonatomic, strong) NSString *C_A70600_C_ID;
@property (nonatomic, strong) NSString *C_A70600_C_NAME;
@property (nonatomic, strong) NSString *C_ADDRESS;
@property (nonatomic, strong) NSString *C_BIRTHDAY_TIME;
@property (nonatomic, strong) NSString *C_BUYTYPE_DD_ID;
@property (nonatomic, strong) NSString *C_BUYTYPE_DD_NAME;
@property (nonatomic, strong) NSString *C_CITY;
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_ID;
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_NAME;
@property (nonatomic, strong) NSString *C_COMPANY;
@property (nonatomic, strong) NSString *C_DESIGNER_ROLEID;
@property (nonatomic, strong) NSString *C_DESIGNER_ROLENAME;
@property (nonatomic, strong) NSString *C_EDUCATION_DD_ID;
@property (nonatomic, strong) NSString *C_EDUCATION_DD_NAME;
@property (nonatomic, strong) NSString *C_EXISTING;
@property (nonatomic, strong) NSString *C_HEADIMGURL;
@property (nonatomic, strong) NSString *C_HEADIMGURL_SHOW;
@property (nonatomic, strong) NSString *C_HOBBY_DD_ID;
@property (nonatomic, strong) NSString *C_HOBBY_DD_NAME;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_INDUSTRY_DD_ID;
@property (nonatomic, strong) NSString *C_INDUSTRY_DD_NAME;
@property (nonatomic, strong) NSString *C_INDUSTRY;
@property (nonatomic, strong) NSString *D_ANNIVERSARY_TIME;
@property (nonatomic, strong) NSString *D_BIRTHDAY_TIME;
@property (nonatomic, strong) NSString *C_ENGLISHNAME;
@property (nonatomic, strong) NSString *C_HOBBY;
@property (nonatomic, strong) NSString *C_LEVEL_DD_ID;
@property (nonatomic, strong) NSString *C_LEVEL_DD_NAME;
@property (nonatomic, strong) NSString *C_LICENSE_PLATE;
@property (nonatomic, strong) NSString *C_MARITALSTATUS_DD_ID;
@property (nonatomic, strong) NSString *C_MARITALSTATUS_DD_NAME;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_OCCUPATION_DD_NAME;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSString *C_PHONE;
@property (nonatomic, strong) NSString *C_PROVINCE;
@property (nonatomic, strong) NSString *C_SALARY_DD_ID;
@property (nonatomic, strong) NSString *C_SALARY_DD_NAME;
@property (nonatomic, strong) NSString *C_SEX_DD_ID;
@property (nonatomic, strong) NSString *C_SEX_DD_NAME;
@property (nonatomic, strong) NSString *C_STAR_DD_ID;
@property (nonatomic, strong) NSString *C_STAR_DD_NAME;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSString *C_WECHAT;
@property (nonatomic, strong) NSString *C_YS_DD_ID;
@property (nonatomic, strong) NSString *C_YS_DD_NAME;
@property (nonatomic, strong) NSString *C_PAYMENT_DD_ID;
@property (nonatomic, strong) NSString *C_PAYMENT_DD_NAME;
@property (nonatomic, strong) NSString *D_CREATE_TIME;
@property (nonatomic, strong) NSString *I_SORTIDX;
@property (nonatomic, strong) NSString *X_LABEL;
@property (nonatomic, strong) NSString *X_REMARK;
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
/** <#注释#> */
@property (nonatomic, strong) NSString *I_INTEGRAL;
@property (nonatomic, strong) NSArray *fileList;
@property (nonatomic, strong) NSArray *labelsList;

@end

@interface CustomerListModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSArray *content;
@end

NS_ASSUME_NONNULL_END
