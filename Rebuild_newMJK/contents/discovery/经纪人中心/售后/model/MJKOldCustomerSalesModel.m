//
//  MJKOldCustomerSalesModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/11/4.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKOldCustomerSalesModel.h"
#import "VideoAndImageModel.h"


@implementation MJKOldCustomerSalesMainModel
+  (NSDictionary *)mj_objectClassInArray {
    return @{@"content" : @"MJKOldCustomerSalesModel"};
}
@end

@implementation MJKOldCustomerSalesModel
+  (NSDictionary *)mj_objectClassInArray {
    return @{@"fileListGzImage" : @"VideoAndImageModel",  @"fileListGzVideo" : @"VideoAndImageModel",  @"fileListGlsImage" : @"VideoAndImageModel",  @"fileListXszImage" : @"VideoAndImageModel" };
}
@end
