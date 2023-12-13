//
//  MJKOrderRecordModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MJKOrderRecordMainModel : MJKBaseModel
@property (nonatomic, strong) NSString *yfTotal;

@end

@interface MJKOrderRecordModel : MJKBaseModel

@property (nonatomic, strong) NSString *AMOUNT;
@property (nonatomic, strong) NSString *C_A04200_C_ID;
@property (nonatomic, strong) NSString *C_A41500_C_ID;
@property (nonatomic, strong) NSString *C_A41500_C_NAME;
@property (nonatomic, strong) NSString *C_OWNER_ROLEID;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSString *C_PAYCHANNEL;
@property (nonatomic, strong) NSString *D_CREATE_DATE;
@property (nonatomic, strong) NSString *D_CREATE_TIME;
@property (nonatomic, strong) NSString *X_REMARK;
@property (nonatomic, strong) NSString * C_TYPE_DD_NAME;
@property (nonatomic, strong) NSString * C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *wfTotal;
@end
