//
//  MJKAddMRModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/23.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKAddMRModel : MJKBaseModel
/** <#备注#>*/
@property (nonatomic, strong) NSString *CODE;
@property (nonatomic, strong) NSString *COUNT;
@property (nonatomic, strong) NSString *NAME;

/** flag*/
@property (nonatomic, assign) BOOL flag;


/** 今日计划数*/
@property (nonatomic, strong) NSString *B_TOTAL_JH;
/** 与B_TOTAL_JH字段同一个层的X_REMARK，返回的是数量细分后的备注*/
@property (nonatomic, strong) NSString *X_REMARK;

/** 明日计划数*/
@property (nonatomic, strong) NSString *B_TOTAL_JH_MR;

/** 本月目标数*/
@property (nonatomic, strong) NSString *I_TARGETNUMBER;

/** 本月完成数*/
@property (nonatomic, strong) NSString *B_TOTAL_BY;
@end

NS_ASSUME_NONNULL_END
