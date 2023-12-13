//
//  MJKPersonalPerformanceTargetModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/14.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKPersonalPerformanceTargetModel : MJKBaseModel
/** 目标类型code*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** 目标类型*/
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
/** 目标id（如果为空以下值全为空串，在更新时需要app生成C_ID，规则A70900-加随机数*/
@property (nonatomic, strong) NSString *C_ID;
/** 目标归属年月*/
@property (nonatomic, strong) NSString *C_YEARMONTH;
/** 目标状态code*/
@property (nonatomic, strong) NSString *C_SATUS_DD_ID;
/** 目标状态*/
@property (nonatomic, strong) NSString *C_SATUS_DD_NAME;
/** 目标数*/
@property (nonatomic, strong) NSString *I_TARGETNUMBER;
@end

NS_ASSUME_NONNULL_END
