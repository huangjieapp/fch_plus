//
//  MJKJFDetailModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MJKJFDetailModel : MJKBaseModel
/** 员工姓名*/
@property (nonatomic, strong) NSString *C_NAME;
/** 积分list*/
@property (nonatomic, strong) NSArray *personalDetails;
@end

@interface MJKJFSubModel : MJKBaseModel
/** 个数/分数*/
@property (nonatomic, strong) NSString *I_INTEGRAL;
/** 积分类型code*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** 积分类型*/
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
@end

