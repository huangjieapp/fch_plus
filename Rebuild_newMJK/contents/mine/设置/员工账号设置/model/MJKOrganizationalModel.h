//
//  MJKOrganizationalModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2018/12/18.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKOrganizationalModel : MJKBaseModel
/** 组织架构id*/
@property (nonatomic, strong) NSString *C_U00100_C_ID;
/** 组织架构*/
@property (nonatomic, strong) NSString *C_U00100_C_NAME;
/** 下级的list*/
@property (nonatomic, strong) NSArray *xjList;

/** <#注释#>*/
@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
