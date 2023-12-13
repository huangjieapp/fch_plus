//
//  MJKShoppingCartMoedel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKShoppingCartMoedel : NSObject
/** 商品id*/
@property (nonatomic, strong) NSString *C_ID;

/** 活动价*/
@property (nonatomic, strong) NSString *C_HDJ;

/** 商品类型*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;

/** 商品数量*/
@property (nonatomic, assign) NSInteger num;

@end

NS_ASSUME_NONNULL_END
