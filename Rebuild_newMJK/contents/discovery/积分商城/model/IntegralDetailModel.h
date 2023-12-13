//
//  IntegralDetailModel.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/14.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegralDetailModel : MJKBaseModel

/**
 描述
 */
@property (nonatomic, copy) NSString *customfields;
/**
 商品名称
 */
@property (nonatomic, copy) NSString *name;
/**
 图片列表
 */
@property (nonatomic, strong) NSMutableArray *pictureList;
/**
 参考价
 */
@property (nonatomic, copy) NSString *price;
/**
 积分
 */
@property (nonatomic, copy) NSString *awardfactor1;
/**
 商品规格
 */
@property (nonatomic, copy) NSString *specification;

@property (nonatomic, copy) NSString *sid;

@end
