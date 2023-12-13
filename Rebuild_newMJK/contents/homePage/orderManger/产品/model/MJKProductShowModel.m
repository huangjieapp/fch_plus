//
//  MJKProductShowModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/25.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKProductShowModel.h"

@implementation MJKProductShowModel
- (id)copyWithZone:(NSZone *)zone {
    MJKProductShowModel *model = [[MJKProductShowModel allocWithZone:zone]init];
    model.C_ID = self.C_ID;
    model.X_REMARK = self.X_REMARK;
    model.D_START_TIME = self.D_START_TIME;
    model.D_END_TIME = self.D_START_TIME;
    model.X_KQXQPICURL = self.X_KQXQPICURL;
    model.X_FMPICURL = self.X_FMPICURL;
    model.C_A49500_C_ID = self.C_A49500_C_ID;
    model.B_YJ = self.B_YJ;
    model.B_HDJ = self.B_HDJ;
    model.C_NAME = self.C_NAME;
    model.C_TYPE_DD_ID = self.C_TYPE_DD_ID;
    model.C_TYPE_DD_NAME = self.C_TYPE_DD_NAME;
    model.number = self.number;
    return model;
}

- (id)mutableCopyWithZone:(NSZone *)zone  {
    MJKProductShowModel *model = [[MJKProductShowModel allocWithZone:zone]init];
    model.C_ID = self.C_ID;
    model.X_REMARK = self.X_REMARK;
    model.D_START_TIME = self.D_START_TIME;
    model.D_END_TIME = self.D_START_TIME;
    model.X_KQXQPICURL = self.X_KQXQPICURL;
    model.X_FMPICURL = self.X_FMPICURL;
    model.C_A49500_C_ID = self.C_A49500_C_ID;
    model.B_YJ = self.B_YJ;
    model.B_HDJ = self.B_HDJ;
    model.C_NAME = self.C_NAME;
    model.C_TYPE_DD_ID = self.C_TYPE_DD_ID;
    model.C_TYPE_DD_NAME = self.C_TYPE_DD_NAME;
    model.number = self.number;
    return model;
}




@end
