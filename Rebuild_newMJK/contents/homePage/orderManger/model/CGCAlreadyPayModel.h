//
//  CGCAlreadyPayModel.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGCAlreadyPayModel : MJKBaseModel

///
@property(nonatomic,strong) NSString * AMOUNT;
///
@property(nonatomic,strong) NSString * C_A04200_C_ID;
///
@property(nonatomic,copy) NSString * C_PAYCHANNEL;
///
@property(nonatomic,copy) NSString * D_CREATE_TIME;
///
@property(nonatomic,copy) NSString * X_REMARK;

@end
