//
//  MJKShowAreaModel.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/11.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKShowAreaModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_ADDRESS;
@property (nonatomic, strong) NSString *B_LONGITUDE;
@property (nonatomic, strong) NSString *B_LATITUDE;
@property (nonatomic, strong) NSString *C_PROVINCE;
@property (nonatomic, strong) NSString *C_CITY;
@property (nonatomic, strong) NSString *C_PROPERTY;
@property (nonatomic, strong) NSString *I_HOUSEHOLDS;
@property (nonatomic, strong) NSString *C_NAMEANDADDRESS;

/** <#注释#>*/
@property (nonatomic, getter=isSelected) BOOL selected;
@end
