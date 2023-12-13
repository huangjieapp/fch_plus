//
//  CGCNewAaddAppiontModel.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/30.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGCNewAaddAppiontModel : MJKBaseModel


///预约C_ID
@property(nonatomic,strong) NSString * C_ID;
///客户姓名
@property(nonatomic,strong) NSString * C_NAME;
///联系电话
@property(nonatomic,copy) NSString * C_PHONE;
///预约时间
@property(nonatomic,copy) NSString * D_BOOK_TIME;
///预约备注
@property(nonatomic,copy) NSString * X_REMARK;
///意向车型
@property(nonatomic,copy) NSString * C_A40600_C_ID;
///性别
@property(nonatomic,copy) NSString * C_SEX_DD_ID;
///销售顾问
@property(nonatomic,copy) NSString * C_OWNER_ROLEID;

@property(nonatomic,copy) NSString * C_A41500_C_NAME;

@property(nonatomic,copy) NSString * C_A41500_C_ID;

///性别名
@property(nonatomic,copy) NSString * C_SEX_DD_NAME;
@property(nonatomic,copy) NSString *C_MODEFOLLOW_DD_ID;
@property(nonatomic,copy) NSString *C_MODEFOLLOW_DD_NAME;

@property(nonatomic,copy) NSString *C_ISDRIVE_DD_ID;
@property(nonatomic,copy) NSString *C_ISDRIVE_DD_NAME;

///销售顾问
@property(nonatomic,copy) NSString * C_OWNER_ROLENAME;

@property (nonatomic, copy) NSString *C_WECHART;
@end
