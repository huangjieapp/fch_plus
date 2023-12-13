//
//  CGCBrokerCenterVC.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/10.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "DBBaseViewController.h"
#import "CGCCustomModel.h"

typedef enum : NSUInteger {
    BrokerCenterAgent,
    BrokerCenterMembers,
} BrokerCenterType;

@interface CGCBrokerCenterVC : DBBaseViewController
/** <#注释#>*/
@property (nonatomic, strong) NSString *loudou;
/** tabSearchStr*/
@property (nonatomic, strong) NSString *tabSearchStr;

/** <#注释#>*/
@property (nonatomic, strong) NSString *LASTFOLLOW_TIME_TYPE;
@property (nonatomic, strong) NSString *LASTFOLLOW_START_TIME;
@property (nonatomic, strong) NSString *LASTFOLLOW_END_TIME;
/** isAdd*/
@property (nonatomic, assign) BOOL isAdd;
/** <#备注#>*/
@property (nonatomic, assign) BOOL isTab;
@property (nonatomic, strong) NSString *textFieldText;


@property (nonatomic, copy) NSString *C_STATUS_DD_ID;

@property (nonatomic, copy) NSString *VCName;
@property (nonatomic, copy) NSString *typeName;

/** 经纪人/会员的type*/
@property (nonatomic, assign) BrokerCenterType type;
@property (nonatomic, copy) NSString *C_TYPE_DD_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *CREATE_TIME_TYPE;
/** <#注释#>*/
@property (nonatomic, strong) NSString *SEARCH_TYPE;
/** <#注释#> */
@property (nonatomic, strong) NSString *index;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_FSLX_DD_ID;
/** 选中返回*/
@property (nonatomic, copy) void(^backSelectFansBlock)(CGCCustomModel *model);

@end
