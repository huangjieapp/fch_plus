//
//  MJKPKGroupPeopleModel.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKPKGroupPeopleModel : MJKBaseModel
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *USER_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_HEADPIC;
/** 是否已分pk组 返回true和false*/
@property (nonatomic, strong) NSString *checkFlag;
/** checkFlag返回true时，这里是组的名称*/
@property (nonatomic, strong) NSString *gourpName;
@property (nonatomic, strong) NSString *gourpName_gzhb;

@property (nonatomic, strong) NSString *deptName;

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *u031Id;

@property (nonatomic, strong) NSString *u051Id;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *phonenumber;

@property (nonatomic, getter=isSelected) BOOL selected;
@end
