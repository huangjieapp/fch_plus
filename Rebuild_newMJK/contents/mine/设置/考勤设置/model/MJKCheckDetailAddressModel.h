//
//  MJKCheckDetailAddressModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/10.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKCheckDetailAddressModel : MJKBaseModel
/** 地点id*/
@property (nonatomic, strong) NSString *C_ID;
/** 地点名称*/
@property (nonatomic, strong) NSString *C_NAME;
/** 纬度*/
@property (nonatomic, strong) NSNumber *B_SIGNLATITUDE;
/** 经度*/
@property (nonatomic, strong) NSNumber *B_SIGNLONGITUDE;
@end
