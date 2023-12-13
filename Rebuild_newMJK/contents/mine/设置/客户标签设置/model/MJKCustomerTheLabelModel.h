//
//  MJKCustomerTheLabelModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/15.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCustomerTheLabelModel : MJKBaseModel
/** 标签类型id*/
@property (nonatomic, strong) NSString *type_id;
/** 标签类型名称*/
@property (nonatomic, strong) NSString *type_name;
/** C_COLOR_DD_ID*/
@property (nonatomic, strong) NSString *C_COLOR_DD_ID;
/** content*/
@property (nonatomic, strong) NSArray *content;
@end

NS_ASSUME_NONNULL_END
