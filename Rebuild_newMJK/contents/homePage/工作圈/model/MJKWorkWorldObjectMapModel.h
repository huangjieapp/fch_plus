//
//  MJKWorkWorldObjectMapModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/23.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKWorkWorldObjectMapModel : MJKBaseModel
/** <#备注#>*/
@property (nonatomic, strong) NSString *B_AMOUNT;
@property (nonatomic, strong) NSString *B_HJJE;
@property (nonatomic, strong) NSString *B_TZJE;
@property (nonatomic, strong) NSString *C_HEADIMGURL;
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *D_CREATE_TIME;
/** <#备注#>*/
@property (nonatomic, strong) NSString *D_LASTUPDATE_TIME;
/** <#备注#>*/
@property (nonatomic, strong) NSString *USERID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *USERNAME;
/** <#备注#>*/
@property (nonatomic, strong) NSString *X_MRPLAN;
/** <#备注#>*/
@property (nonatomic, strong) NSString *X_MRPLANDETAILED;
/** <#备注#>*/
@property (nonatomic, strong) NSString *X_REMARK;
/** <#备注#>*/
@property (nonatomic, strong) NSString *X_ZRPLAN;
/** <#备注#>*/
@property (nonatomic, strong) NSString *X_ZRPLANDETAILED;
/** <#备注#>*/
@property (nonatomic, strong) NSString *comments;
/** <#备注#>*/
@property (nonatomic, strong) NSArray *content;
/** <#备注#>*/
@property (nonatomic, strong) NSString *fabulous;
/** <#备注#>*/
@property (nonatomic, strong) NSString *fabulous_flag;

@property (nonatomic, strong) NSString *C_OWNER_ROLEID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
/** <#备注#>*/
@property (nonatomic, strong) NSArray *urlList;
@property (nonatomic, strong) NSString *C_OBJECTID;


/** <#备注#>*/
@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
