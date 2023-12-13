//
//  MJKCustomerSeaSubModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKCustomerSeaSubModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_ID;//客户id
@property (nonatomic, strong) NSString *C_NAME;//客户姓名
@property (nonatomic, strong) NSString *C_SEX_DD_ID;//性别id
@property (nonatomic, strong) NSString *C_SEX_DD_NAME;//性别
@property (nonatomic, strong) NSString *C_STAR_DD_ID;//星标id
@property (nonatomic, strong) NSString *C_STAR_DD_NAME;//星标
@property (nonatomic, strong) NSString *C_LEVEL_DD_ID;//等级id
@property (nonatomic, strong) NSString *C_LEVEL_DD_NAME;//等级
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;//状态id
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;//状态
@property (nonatomic, strong) NSString *C_ADDRESS;//地址
@property (nonatomic, strong) NSString *C_HEADIMGURL;//头像
@property (nonatomic, strong) NSString *C_SOURCEOWNERID;//归还人id
@property (nonatomic, strong) NSString *C_SOURCEOWNERNAME;//归还人姓名
@property (nonatomic, strong) NSString *D_CHANGEIN_TIME;//归还时间
@property (nonatomic, strong) NSString *C_CHANGEINTO_DD_ID;//归还方式id
@property (nonatomic, strong) NSString *C_CHANGEINTO_DD_NAME;//归还方式
/** <#备注#>*/
@property (nonatomic, getter=isSelected) BOOL selected;

@end
