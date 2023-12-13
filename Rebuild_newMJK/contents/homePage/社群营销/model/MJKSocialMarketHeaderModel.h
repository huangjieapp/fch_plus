//
//  MJKSocialMarketHeaderModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/26.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKSocialMarketHeaderModel : MJKBaseModel
/** 阅读名片数*/
@property (nonatomic, strong) NSString *readMpNumber;
/** 阅读素材数*/
@property (nonatomic, strong) NSString *readScNumber;
/** 阅读活动数*/
@property (nonatomic, strong) NSString *readHdNumber;
/** 阅读商品数*/
@property (nonatomic, strong) NSString *readSpNumber;
/** 参加活动数*/
@property (nonatomic, strong) NSString *participateActivityNumber;
/** 留下电话*/
@property (nonatomic, strong) NSString *phoneNumber;
/** 意向客户*/
@property (nonatomic, strong) NSString *customerNumber;
/** 购买商品*/
@property (nonatomic, strong) NSString *purchaseGoodsNumber;
/** 参加活动*/
@property (nonatomic, strong) NSString *shareNumber;
/** 浏览人数*/
@property (nonatomic, strong) NSString *readNumber;
/** 浏览量*/
@property (nonatomic, strong) NSString *readCount;
/** 转发数*/
@property (nonatomic, strong) NSString *forwardNumber;

/** <#注释#>*/
@property (nonatomic, strong) NSString *allReadCount;
@property (nonatomic, strong) NSString *allReadNumber;
@property (nonatomic, strong) NSString *allForwardNumber;
@property (nonatomic, strong) NSString *allShareNumber;
@end

NS_ASSUME_NONNULL_END
