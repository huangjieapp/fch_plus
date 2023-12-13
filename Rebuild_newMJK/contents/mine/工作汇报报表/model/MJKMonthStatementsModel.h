//
//  MJKMonthStatementsModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/8.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKMonthStatementsModel : MJKBaseModel
/** 姓名*/
@property (nonatomic, strong) NSString *C_NAME;
/** 头像*/
@property (nonatomic, strong) NSString *C_HEADIMGURL;
/** 地址*/
@property (nonatomic, strong) NSString *C_ADDRESS;
/** userid*/
@property (nonatomic, strong) NSString *C_U03100_C_ID;
/** 详细状况*/
@property (nonatomic, strong) NSArray *statusContent;

@end
