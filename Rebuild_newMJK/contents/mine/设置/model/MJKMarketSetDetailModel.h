//
//  MJKMarketSetDetailModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKMarketSetDetailModel : MJKBaseModel

@property (nonatomic, strong) NSString *C_ID;//市场活动ID
@property (nonatomic, strong) NSString *C_NAME;//市场活动名称
@property (nonatomic, strong) NSString *C_VOUCHERID;//市场活动代码
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;//活动状态ID
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;//活动状态名称
@property (nonatomic, strong) NSString *D_START_TIME;//开始时间
@property (nonatomic, strong) NSString *D_END_TIME;//结束时间
@property (nonatomic, strong) NSString *X_REMARK;//备注
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_ID;//潜客来源ID
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_NAME;//潜客来源
@end
