//
//  MJKVacationContentModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/7.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKVacationContentModel : MJKBaseModel
/** 项目code*/
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
/** 项目名称*/
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
/** 当月日期*/
@property (nonatomic, strong) NSString *DAYNUMBER;
@end
