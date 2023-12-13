//
//  CustomerLevelModel.m
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import "CustomerLevelModel.h"

@implementation CustomerLevelSubModel

@end

@implementation CustomerLevelModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list": [CustomerLevelSubModel class]};
}
@end
