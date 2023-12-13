//
//  MJKSingleModel.h
//  Rebuild_newMJK
//
//  Created by Mcr on 2018/4/19.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKSingleModel : MJKBaseModel

@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *D_FOLLOW_TIME;
@property (nonatomic, strong) NSString *X_REMARK;
@property (nonatomic, strong) NSString *B_DRIVE_LON;
@property (nonatomic, strong) NSString *B_DRIVE_LAT;
@property (nonatomic, strong) NSString *C_DRIVE_ADDRESS;
@property (nonatomic, strong) NSString *C_A41500_C_ID;
@property (nonatomic, strong) NSString *C_A41500_C_NAME;
@property (nonatomic, strong) NSString *C_A01200_C_ID;
@property (nonatomic, strong) NSString *C_A01200_C_NAME;
@property (nonatomic, strong) NSString *X_PICURL;
@property (nonatomic, strong) NSString *C_OWNER_ROLEID;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSArray *urlList;
/** 是否需要新增工作圈记录
 需要传1*/
@property (nonatomic, strong) NSString *IS_WORKCIRCLE;
/** 工作圈中的提醒谁看，将选中的userd以逗号隔开传进来*/
@property (nonatomic, strong) NSString *X_REMINDING;
@end
