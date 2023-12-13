//
//  MJKPhoneSetListSubModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/14.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKPhoneSetListSubModel : MJKBaseModel

@property (nonatomic, strong) NSString *C_GROUPPHONE;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSString *total;//话机来源（市场活动）
@property (nonatomic, strong) NSString *totalId;//投放来源id
@property (nonatomic, strong) NSString *totalphone;//投放来源话机号码

//电话详情
@property (nonatomic, strong) NSString *C_U03100_C_ID;//销售ID
@property (nonatomic, strong) NSString *C_U03100_C_NAME;//销售名字
@end
