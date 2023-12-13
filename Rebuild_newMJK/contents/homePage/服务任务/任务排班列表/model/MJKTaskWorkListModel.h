//
//  MJKTaskWorkListModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/30.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTaskWorkListModel : MJKBaseModel
/** 员工id*/
@property (nonatomic, strong) NSString *USER_ID;
/** 员工姓名*/
@property (nonatomic, strong) NSString *USER_NAME;
/** 员工头像*/
@property (nonatomic, strong) NSString *C_HEADIMGURL;
/** 优先级高的个数*/
@property (nonatomic, strong) NSString *A01200_C_TASKSTATUS_0000;
/** 优先级中的个数*/
@property (nonatomic, strong) NSString *A01200_C_TASKSTATUS_0001;
/** 优先级低的个数*/
@property (nonatomic, strong) NSString *A01200_C_TASKSTATUS_0002;

/** 员工id*/
@property (nonatomic, strong) NSString *USERID;
/** 员工姓名*/
@property (nonatomic, strong) NSString *USERNAME;
/** 员工头像*/
@property (nonatomic, strong) NSString *timeOutCount;
@property (nonatomic, strong) NSArray *rwfbList;
@end

NS_ASSUME_NONNULL_END
