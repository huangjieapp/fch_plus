//
//  MJKCustomerLabelModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/15.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCustomerLabelModel : MJKBaseModel
/** 标签类型id*/
@property (nonatomic, strong) NSString *C_ID;
/** 类型名称*/
@property (nonatomic, strong) NSString *C_NAME;
/** 颜色码*/
@property (nonatomic, strong) NSString *C_COLOR_DD_ID;
@end

NS_ASSUME_NONNULL_END
