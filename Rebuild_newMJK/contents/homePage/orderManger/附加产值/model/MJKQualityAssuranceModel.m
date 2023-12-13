//
//  MJKQualityAssuranceModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/1.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKQualityAssuranceModel.h"

@implementation MJKQualityAssuranceMainModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content": @"MJKQualityAssuranceModel"};
}
@end

@implementation MJKQualityAssuranceModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"fileListZb":@"VideoAndImageModel", @"fileListLr":@"VideoAndImageModel"};
}
@end
