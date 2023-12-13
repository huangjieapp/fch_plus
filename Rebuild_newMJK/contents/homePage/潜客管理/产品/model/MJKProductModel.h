//
//  MJKProductModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKProductModel : MJKBaseModel
/** 产品单价*/
@property (nonatomic, strong) NSString *B_PRICE;
/** 产品id*/
@property (nonatomic, strong) NSString *C_A41900_C_ID;
/** 产品名称*/
@property (nonatomic, strong) NSString *C_A41900_C_NAME;
/** 勾中的意向id*/
@property (nonatomic, strong) NSString *C_ID;
/** 产品编码*/
@property (nonatomic, strong) NSString *C_PRODUCTCODE;
/** 勾中返回true
 没勾中返回fals*/
@property (nonatomic, strong) NSString *flag;
@end
