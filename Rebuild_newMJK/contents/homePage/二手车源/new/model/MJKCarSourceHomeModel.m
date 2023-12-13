//
//  MJKCarSourceHomeModel.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/19.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKCarSourceHomeModel.h"

#import "VideoAndImageModel.h"

@implementation MJKCarSourceHomeModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content" : @"MJKCarSourceHomeSubModel"};
}
@end

@implementation MJKCarSourceHomeSubModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"fileListFp": @"VideoAndImageModel", @"fileListYs": @"VideoAndImageModel"};
}

@end

@implementation MJKCarSourceLockModel

@end

@implementation MJKCarSourceWLModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"fileList": @"VideoAndImageModel"};
}
@end

@implementation MJKCarSourceGJModel


@end
