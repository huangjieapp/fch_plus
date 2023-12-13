//
//  MJKMJKAttendanceDetailModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/30.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKMJKAttendanceDetailModel : MJKBaseModel
/** 当日已考勤上班时间*/
@property (nonatomic, strong) NSString *D_TOWORK_TIME;
/** 当日已考勤下班时间*/
@property (nonatomic, strong) NSString *D_OFFWORK_TIME;
/** 返回true 上班已考勤
 返回false 上班未考勤*/
@property (nonatomic, strong) NSString *toworkFlag;
/** 返回true 下班已考勤
 返回false 下班未考勤*/
@property (nonatomic, strong) NSString *offworkFlag;
@end
