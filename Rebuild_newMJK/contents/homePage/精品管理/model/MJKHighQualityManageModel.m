//
//  MJKRegisterManageModel.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/11/2.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKHighQualityManageModel.h"
#import "VideoAndImageModel.h"

@implementation MJKHighQualityManageMainModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content": @"MJKHighQualityManageModel"};
}
@end

@implementation MJKHighQualityManageModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"fileListDjzs":@"VideoAndImageModel", @"fileListXsz":@"VideoAndImageModel"};
}
@end
