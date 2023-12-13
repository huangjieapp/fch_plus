//
//  MJKSocialMarketTeamListModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKSocialMarketTeamListModel : MJKBaseModel
/** accountid*/
@property (nonatomic, strong) NSString *cid;
/** <#注释#>*/
@property (nonatomic, strong) NSString *faceurl;
/** 名字*/
@property (nonatomic, strong) NSString *name;
/** userToken*/
@property (nonatomic, strong) NSString *objectid;
/** openid*/
@property (nonatomic, strong) NSString *openid;
/** 阅读量*/
@property (nonatomic, strong) NSString *readCount;
/** 阅读人数*/
@property (nonatomic, strong) NSString *readNumber;
/** 分享数*/
@property (nonatomic, strong) NSString *shareNumber;
/** 团队数*/
@property (nonatomic, strong) NSString *teamNumber;
/** 意向客户*/
@property (nonatomic, strong) NSString *customerCount;
@property (nonatomic, strong) NSString *materialNumber;
@property (nonatomic, strong) NSString *forwardNumber;

@property (nonatomic, strong) NSString *allReadCount;
@property (nonatomic, strong) NSString *allReadNumber;
@property (nonatomic, strong) NSString *allForwardNumber;
@property (nonatomic, strong) NSString *allShareNumber;

@end

NS_ASSUME_NONNULL_END
