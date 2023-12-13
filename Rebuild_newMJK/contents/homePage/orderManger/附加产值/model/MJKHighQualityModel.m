//
//  MJKHighQualityModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/4.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKHighQualityModel.h"
#import "VideoAndImageModel.h"

@implementation MJKHighQualityModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"fileListImage": @"VideoAndImageModel"};
}
@end
