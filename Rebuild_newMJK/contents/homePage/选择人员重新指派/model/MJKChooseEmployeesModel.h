//
//  MJKChooseEmployeesModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/5.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKChooseEmployeesModel : MJKBaseModel
/** 门店名称*/
@property (nonatomic, strong) NSString *storeName;
/** 门店下所有帐号*/
@property (nonatomic, strong) NSArray *userList;
/** <#注释#>*/
@property (nonatomic, getter=isSelected) BOOL selected;


@property (nonatomic, strong) NSString *B_COMMISION;
@property (nonatomic, strong) NSString *C_VOUCHERID;
@property (nonatomic, strong) NSString *B_MONEY;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@end

NS_ASSUME_NONNULL_END
