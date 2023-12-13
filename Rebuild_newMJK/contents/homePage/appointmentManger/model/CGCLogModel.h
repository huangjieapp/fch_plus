//
//  CGCLogModel.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/1.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGCLogModel : MJKBaseModel

@property(nonatomic,strong) NSString *  C_ID;

@property(nonatomic,strong) NSString * C_OBJECTID;

@property(nonatomic,copy) NSString * C_OWNER_ROLENAME;

@property(nonatomic,copy) NSString * D_CREATE_TIME;

@property(nonatomic,copy) NSString * X_REMARK;

@property(nonatomic,copy) NSString * C_A70100_C_ID;
@property(nonatomic,copy) NSString * C_A70100_C_NAME;

/** 拨打时间*/
@property (nonatomic, strong) NSString *calldatetime;
/** 话术事件名称*/
@property (nonatomic, strong) NSString *nlpEventName;

/** X_DETAILS*/
@property (nonatomic, strong) NSString *X_DETAILS;
@end
