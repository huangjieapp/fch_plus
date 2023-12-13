//
//  MJKTaskClockModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/2/22.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTaskClockModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *X_REMARK;
@property (nonatomic, strong) NSString *C_OWNER_ROLEID;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;

@property (nonatomic, strong) NSString *C_BHGYY_DD_ID;
@property (nonatomic, strong) NSString *C_BHGYY_DD_NAME;
@property (nonatomic, strong) NSString *C_VOUCHERID;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *urlList;
@property (nonatomic, strong) NSArray *fileList;
@end

NS_ASSUME_NONNULL_END
