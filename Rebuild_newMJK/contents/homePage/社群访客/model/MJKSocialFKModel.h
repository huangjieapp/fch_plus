//
//  MJKSocialFKModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKSocialFKModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *faceurl;
/** 团队数*/
@property (nonatomic, strong) NSString *teamNumber;
/** 累计访客数*/
@property (nonatomic, strong) NSString *allVisitorNumber;
/** 今日活跃数*/
@property (nonatomic, strong) NSString *activeNumber;
/** 新客户数*/
@property (nonatomic, strong) NSString *customerNumber;
/** accountid*/
@property (nonatomic, strong) NSString *cid;
/** 名字*/
@property (nonatomic, strong) NSString *name;
/** userToken*/
@property (nonatomic, strong) NSString *objectid;
/** openid*/
@property (nonatomic, strong) NSString *nameopenid;


@property (nonatomic, strong) NSString *a415id;
@property (nonatomic, strong) NSString *allinteractionNumber;
@property (nonatomic, strong) NSString *c006id;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *customerRemark;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *groupid;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *interactionNumber;
//@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *salername;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *sourceType;
@property (nonatomic, strong) NSString *url;
@end

NS_ASSUME_NONNULL_END
