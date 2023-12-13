//
//  CustomerListModel.m
//  match
//
//  Created by huangjie on 2022/7/27.
//

#import "CustomerListModel.h"


@implementation CustomerListSubModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"fileList": @"VideoAndImageModel"};
}
@end

@implementation CustomerListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content": @"CustomerListSubModel"};
}
@end
