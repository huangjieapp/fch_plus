//
//  MJKAgentListModel.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKAgentListModel : MJKBaseModel
/** 经纪人ID*/
@property(nonatomic,strong) NSString *C_ID;
/** 经纪人姓名*/
@property(nonatomic,strong) NSString *C_NAME;
/** 经纪人小程序ID*/
@property(nonatomic,strong) NSString *C_OBJECTID;
/** */
@property(nonatomic,strong) NSString *C_OPENID;
/** */
@property(nonatomic,strong) NSString *C_PHONE;
/** */
@property(nonatomic,strong) NSString *C_QRCODE;
/** 状态*/
@property(nonatomic,strong) NSString *C_STATUS_DD_NAME;
/** 类型*/
@property(nonatomic,strong) NSString *C_TYPE_DD_NAME;
/** 微信号*/
@property(nonatomic,strong) NSString *C_WECHAT;
/** 积分*/
@property(nonatomic,strong) NSString *I_INTEGRAL;

@end
