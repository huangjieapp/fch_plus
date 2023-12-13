//
//  MJKCallShowDetailModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/4/1.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCallShowDetailModel : MJKBaseModel
/** 名单/粉丝/客户名称*/
@property (nonatomic, strong) NSString *C_NAME;
/** 名单/粉丝/客户号码*/
@property (nonatomic, strong) NSString *C_PHONE;
/** 名单/粉丝/客户id*/
@property (nonatomic, strong) NSString *X_REMARK;
/** 所属人*/
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@end

NS_ASSUME_NONNULL_END
