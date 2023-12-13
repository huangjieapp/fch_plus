//
//  MJKCustomerTheLabelSubModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/15.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCustomerTheLabelSubModel : MJKBaseModel
/** 标签id*/
@property (nonatomic, strong) NSString *C_ID;
/** 标签名称*/
@property (nonatomic, strong) NSString *C_NAME;
/** 标签颜色*/
@property (nonatomic, strong) NSString *C_COLOR_DD_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_COLOR_DD_NAME;
@end

NS_ASSUME_NONNULL_END
