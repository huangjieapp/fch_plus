//
//  MJKMarketSubModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKMarketSubModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_ID;//市场活动
@property (nonatomic, strong) NSString *C_NAME;//市场活动名称
@property (nonatomic, strong) NSString *C_VOUCHERID;//市场活动代码
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;//活动状态ID
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;//活动状态
@property (nonatomic, strong) NSString *D_START_TIME;//开始时间
@property (nonatomic, strong) NSString *D_END_TIME;//结束时间
@property (nonatomic, assign) int countNumber;//总计(当前列表所有的数据条数)
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_NAME;//来源
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_ID;//来源

@end
