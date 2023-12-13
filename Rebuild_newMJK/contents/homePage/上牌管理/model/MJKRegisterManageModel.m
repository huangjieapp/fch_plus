//
//  MJKRegisterManageModel.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/11/2.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKRegisterManageModel.h"
#import "VideoAndImageModel.h"

@implementation MJKRegisterManageMainModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content": @"MJKRegisterManageModel"};
}
@end

@implementation MJKRegisterManageModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"fileListDjzs":@"VideoAndImageModel", @"fileListXsz":@"VideoAndImageModel"};
}
@end
