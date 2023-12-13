//
//  MJKAttendanceModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/10.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKAttendanceModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *B_SIGNLONGITUDE;
@property (nonatomic, strong) NSString *B_SIGNLATITUDE;
@property (nonatomic, strong) NSString *B_SIGNRANGE;
@property (nonatomic, strong) NSString *DISTANCE;
@property (nonatomic, getter=isSelected) BOOL selected;
@end
