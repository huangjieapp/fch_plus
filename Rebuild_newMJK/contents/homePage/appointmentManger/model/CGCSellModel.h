//
//  CGCSellModel.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGCSellModel : MJKBaseModel

/** <#注释#>*/

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *u031Id;

@property (nonatomic, strong) NSString *u051Id;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *LASTUPDATE_TIME_TYPE;
 @property(nonatomic,assign) NSInteger  COUNT;

 @property(nonatomic,strong) NSString * C_HEADPIC;
@property(nonatomic,strong) NSString * C_A70600_C_ID;
@property(nonatomic,strong) NSString * C_A49600_C_ID;

/** <#注释#>*/
@property (nonatomic, strong) NSString *flow_count;

 @property(nonatomic,copy) NSString * C_ID;

 @property(nonatomic,copy) NSString * C_NAME;

 @property(nonatomic,copy) NSString * C_OWNER_ROLEID;

/** 促销活动*/
@property (nonatomic, strong) NSString *C_A40600_C_ID;

//request
@property(nonatomic,strong) NSString * IS_ARRIVE_SHOP;

@property(nonatomic,copy) NSString * USERIDS;

@property(nonatomic,copy) NSString * BOOK_TIME_TYPE;

@property(nonatomic,copy) NSString * C_SEX_DD_ID;

@property(nonatomic,copy) NSString * CREATE_TIME_TYPE;
@property(nonatomic,copy) NSString *CREATE_START_TIME;
@property(nonatomic,copy) NSString *CREATE_END_TIME;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *BOOK_START_TIME;
@property (nonatomic, strong) NSString *BOOK_END_TIME;

@property(nonatomic,copy) NSString * START_CREATE_TIME;

@property(nonatomic,copy) NSString * END_CREATE_TIME;

@property(nonatomic,copy) NSString *C_CLUEPROVIDER_ROLEID;
@property(nonatomic,copy) NSString *C_A47700_C_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_FSLX_DD_ID;

//潜客列表请求
@property(nonatomic,copy) NSString * USER_ID;//销售
/** <#注释#>*/
@property (nonatomic, strong) NSString *user_name;
/** <#注释#>*/
@property (nonatomic, strong) NSString *user_id;

@property(nonatomic,copy) NSString * C_LEVEL_DD_ID;//等级

@property(nonatomic,copy) NSString * C_STATUS_DD_ID;//状态

@property(nonatomic,copy) NSString * TYPE;//排序

@property(nonatomic,copy) NSString * START_TIME;//创建时间

@property(nonatomic,copy) NSString * END_TIME;
@property(nonatomic,copy) NSString * FOLLOW_START_TIME;//下次跟进时间

@property(nonatomic,copy) NSString * FOLLOW_END_TIME;
@property(nonatomic,copy) NSString * LASTUPDATE_START_TIME;//活跃时间

@property(nonatomic,copy) NSString * LASTUPDATE_END_TIME;

@property(nonatomic,copy) NSString * CREATE_TIME;//创建时间

@property(nonatomic,copy) NSString * FOLLOW_TIME;//下次跟进时间

@property(nonatomic,copy) NSString * LASTUPDATE_TIME;//活跃时间

@property(nonatomic,copy) NSString * C_STAR_DD_ID;//星标

@property(nonatomic,copy) NSString * C_CLUESOURCE_DD_ID;//客户来源

@property(nonatomic,copy) NSString * C_A41200_C_ID;//市场活动

@property(nonatomic,copy) NSString * SEARCH_NAMEORCONTACT;

//
@property(nonatomic,copy) NSString * START_TIME_TYPE;

@property(nonatomic,copy) NSString * STATUS_NUMBER;

@property(nonatomic,copy) NSString * JF_START_TIME;

@property(nonatomic,copy) NSString * JF_END_TIME;
@property(nonatomic,copy) NSString * START_BOOK_TIME;
@property(nonatomic,copy) NSString * ARRIVE_TIME_TYPE;
@property(nonatomic,copy) NSString *ARRIVE_START_TIME;
@property(nonatomic,copy) NSString *ARRIVE_END_TIME;
@property(nonatomic,copy) NSString * END_BOOK_TIME;
@property (nonatomic, copy) NSString *FOLLOW_TIME_TYPE;
@property (nonatomic, copy) NSString *LASTFOLLOW_TIME_TYPE;
@property (nonatomic, copy) NSString *LASTFOLLOW_END_TIME;
@property (nonatomic, copy) NSString *C_VIN;
@property (nonatomic, copy) NSString *C_GDSPR;
@property (nonatomic, copy) NSString *C_BILLING;
@property (nonatomic, copy) NSString *approvalStatus;
/** 全部人无论上下级*/
@property (nonatomic, strong) NSString *IS_ALL;
/** 协助人*/
@property (nonatomic, strong) NSString *C_ASSISTANT;

@end
