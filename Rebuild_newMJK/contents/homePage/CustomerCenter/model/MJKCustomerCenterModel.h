//
//  MJKCustomerCenterModel.h
//  Rebuild_newMJK
//
//  Created by Mcr on 2018/5/9.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKCustomerCenterModel : MJKBaseModel
/** 名单流量*/
@property (nonatomic, strong) NSString *LLZX_XS;
/** 来电流量*/
@property (nonatomic, strong) NSString *LLZX_LD;
/** 门店流量*/
@property (nonatomic, strong) NSString *LLZX_MD;
/** 人脸识别*/
@property (nonatomic, strong) NSString *LLZX_LLY;
/** 意向客户*/
@property (nonatomic, strong) NSString *KHZX_QK;
/** 协助客户*/
@property (nonatomic, strong) NSString *KHZX_XZQK;
/** 预约*/
@property (nonatomic, strong) NSString *KHZX_YY;
/** 订金订单*/
@property (nonatomic, strong) NSString *DDZX_DJ;
/** 签约订单*/
@property (nonatomic, strong) NSString *DDZX_QY;
/** 下单订单*/
@property (nonatomic, strong) NSString *DDZX_XD;
/** 安装订单*/
@property (nonatomic, strong) NSString *DDZX_AZ;
/** 完工订单*/
@property (nonatomic, strong) NSString *DDZX_WG;
/** 会员客户*/
@property (nonatomic, strong) NSString *HYZX_HYKH;
@end
