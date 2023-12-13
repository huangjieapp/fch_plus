//
//  CGCIntegarlListModel.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/6/19.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGCIntegarlListModel : MJKBaseModel

@property (nonatomic, copy) NSString *C_A41500_C_ID;

@property (nonatomic, copy) NSString *C_A41500_C_NAME;

@property (nonatomic, copy) NSString *D_CREATE_TIME;

@property (nonatomic, copy) NSString *D_SEND_TIME;

@property (nonatomic, copy) NSString *B_MONTHLYSUPPLY;

@property (nonatomic, assign) BOOL flag;

@property (nonatomic, copy) NSString *C_ID;

@property (nonatomic, copy) NSString *C_NAME;

@property (nonatomic, copy) NSString *C_INTEGRAL;

@property (nonatomic, copy) NSString *C_INTEGRAL_REMARK;

@property (nonatomic, copy) NSString *C_INTEGRALVALUE;

@property (nonatomic, copy) NSString *C_AGENTNAME;

@property (nonatomic, strong) NSMutableArray *content;


@end
