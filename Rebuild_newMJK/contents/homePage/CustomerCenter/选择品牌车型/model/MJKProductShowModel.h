//
//  MJKProductShowModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/25.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKProductShowModel : MJKBaseModel <NSCopying, NSMutableCopying>

@property (nonatomic, strong) NSString *C_ID_ID;
//B_MONEY
@property (nonatomic, strong) NSString *B_MONEY;
/** 活动商品id*/
@property (nonatomic, strong) NSString *C_ID;
/** 商品描述*/
@property (nonatomic, strong) NSString *X_REMARK;
/** 开始时间*/
@property (nonatomic, strong) NSString *D_START_TIME;
/** 结束时间*/
@property (nonatomic, strong) NSString *D_END_TIME;
/** 图片*/
@property (nonatomic, strong) NSString *X_KQXQPICURL;
/** 封面图*/
@property (nonatomic, strong) NSString *X_FMPICURL;
/** 活动管理id*/
@property (nonatomic, strong) NSString *C_A49500_C_ID;
/** 原价*/
@property (nonatomic, strong) NSString *B_YJ;
/** 活动价*/
@property (nonatomic, strong) NSString *B_HDJ;
/** 商品名称*/
@property (nonatomic, strong) NSString *C_NAME;
/** 分类code*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** 分类*/
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;

/** <#注释#>*/
@property (nonatomic, assign) NSInteger number;

/** <#注释#>*/
@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
