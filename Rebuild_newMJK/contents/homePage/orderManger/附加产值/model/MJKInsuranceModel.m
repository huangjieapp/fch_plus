//
//  MJKInsuranceModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/4.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKInsuranceModel.h"
#import "VideoAndImageModel.h"

@implementation MJKInsuranceMainModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content": @"MJKInsuranceModel"};
}
@end

@implementation MJKInsuranceModel
+  (NSDictionary *)mj_objectClassInArray {
    return @{@"fileList":@"VideoAndImageModel"};
}
@end
