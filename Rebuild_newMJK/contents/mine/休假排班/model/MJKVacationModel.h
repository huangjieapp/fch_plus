//
//  MJKVacationModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/7.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKVacationModel : MJKBaseModel
/** 姓名*/
@property (nonatomic, strong) NSString *C_NAME;
/** 头像*/
@property (nonatomic, strong) NSString *C_HEADIMGURL;
/** 地址*/
@property (nonatomic, strong) NSString *C_ADDRESS;
/** 时间*/
@property (nonatomic, strong) NSString *timeStr;
/** content array*/
@property (nonatomic, strong) NSArray *content;

@end
