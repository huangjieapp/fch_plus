//
//  MJKShopArriveContentModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKShopArriveContentModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_ID;//预约C_ID
@property (nonatomic, strong) NSString *C_HEADIMGURL;//头像
@property (nonatomic, strong) NSString *C_A41500_C_ID;//预约人ID
@property (nonatomic, strong) NSString *C_A41500_C_NAME;//预约人姓名
@property (nonatomic, strong) NSString *C_A40600_C_ID;//车型
@property (nonatomic, strong) NSString *D_CREATE_TIME;//创建时间
@property (nonatomic, strong) NSString *USER_ID;//所属销售顾问
@property (nonatomic, strong) NSString *USER_NAME;//所属销售顾问
@property (nonatomic, strong) NSString *D_BOOK_TIME;//预约时间
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_ID_CUSTOMER;//来源渠道
@property (nonatomic, strong) NSString *C_CLUESOURCE_DD_NAME_CUSTOMER;
@property (nonatomic, strong) NSString *C_A41200_C_ID_CUSTOMER;//渠道细分
@property (nonatomic, strong) NSString *C_A41200_C_NAME_CUSTOMER;

@property (nonatomic, getter=isSelected) BOOL selected;
@end
