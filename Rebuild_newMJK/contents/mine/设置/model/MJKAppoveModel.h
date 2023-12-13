//
//  MJKAppoveModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/19.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKAppoveModel : MJKBaseModel

@property (nonatomic, strong) NSString *C_ISAUTOFAIL;//自动战败
@property (nonatomic, strong) NSString *C_ISAUTOACT;//自动激活
@property (nonatomic, strong) NSString *C_ISAUTOPRICE;//价格自动审批
@property (nonatomic, strong) NSString *C_ISAUTOCANCEL;//自动取消审批
@property (nonatomic, strong) NSString *userid;//销售编号
@property (nonatomic, strong) NSString *username;//销售名称


@end
