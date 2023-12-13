//
//  MJKPhoneSetListSaleModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/14.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKPhoneSetListSaleModel : MJKBaseModel

@property (nonatomic, strong) NSString *C_ID;//电话分配C_ID
@property (nonatomic, strong) NSString *C_INTERNAL;//内线号码
@property (nonatomic, strong) NSString *C_U03100_C_ID;//销售id
@property (nonatomic, strong) NSString *C_U03100_C_NAME;//销售

@end
