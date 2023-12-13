//
//  MJKPayModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKPayModel : MJKBaseModel
/** 收款目标*/
@property (nonatomic, strong) NSString *SK_MB;
@property (nonatomic, strong) NSString *MB;
/** 累计完成*/
@property (nonatomic, strong) NSString *SK_MIDCOUNT;
/** 今日完成*/
@property (nonatomic, strong) NSString *SK_JRCOUNT;
/** 日期*/
@property (nonatomic, strong) NSString *dateTime;
/** 金额*/
@property (nonatomic, strong) NSString *SKCOUNT;
/** 占比*/
@property (nonatomic, strong) NSString *WCBL;


/** 帐号id*/
@property (nonatomic, strong) NSString *userid;
/** 帐号*/
@property (nonatomic, strong) NSString *username;


/** 收款id*/
@property (nonatomic, strong) NSString *C_ID;
/** 收款金额*/
@property (nonatomic, strong) NSString *AMOUNT;
/** 帐号roleid*/
@property (nonatomic, strong) NSString *C_OWNER_ROLEID;
/** 员工姓名*/
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSString *NAME;
/** 收款时间*/
@property (nonatomic, strong) NSString *D_COLLECTION_TIME;
/** 收款类型*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;


/** 收款类型*/
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
/** 金额合计*/
@property (nonatomic, strong) NSString *sum;
@property (nonatomic, strong) NSString *num;
@end

NS_ASSUME_NONNULL_END
