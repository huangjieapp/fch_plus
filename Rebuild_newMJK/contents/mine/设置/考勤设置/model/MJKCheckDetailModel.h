//
//  MJKCheckDetailModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/10.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKCheckDetailModel : MJKBaseModel
/** 范围*/
@property (nonatomic, strong) NSString *B_SIGNRANGE;
/** 上班时间*/
@property (nonatomic, strong) NSString *TOWORK_TIME;
/** 下班时间*/
@property (nonatomic, strong) NSString *OFFWORK_TIME;
/** 地点的list*/
@property (nonatomic, strong) NSArray *a64900Forms;
@end
