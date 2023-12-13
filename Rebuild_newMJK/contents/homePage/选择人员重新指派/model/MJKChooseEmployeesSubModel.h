//
//  MJKChooseEmployeesSubModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/5.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKChooseEmployeesSubModel : MJKBaseModel
/** 帐号id*/
@property (nonatomic, strong) NSString *USER_ID;
/** 帐号姓名*/
@property (nonatomic, strong) NSString *C_NAME;
/** 帐号头像*/
@property (nonatomic, strong) NSString *C_HEADPIC;
/** 积分pk分组
 所在组的名称*/
@property (nonatomic, strong) NSString *gourpName;

/** 是否已分pk组
 返回true（是）和false（否）*/
@property (nonatomic, strong) NSString *checkFlag;


@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *u031Id;

@property (nonatomic, strong) NSString *u051Id;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *phonenumber;

/** <#注释#>*/
@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
