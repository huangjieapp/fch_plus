//
//  MJKRegistrationModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/2.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKRegistrationModel.h"
#import "VideoAndImageModel.h"

@implementation MJKRegistrationModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"fileListDjzs" : @"VideoAndImageModel", @"fileListXsz" : @"VideoAndImageModel"};
}
@end
