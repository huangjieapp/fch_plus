//
//  ModuleModel.m
//  match
//
//  Created by huangjie on 2022/8/8.
//

#import "ModuleModel.h"

@implementation ModuleSubModel

@end

@implementation ModuleModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"defaultList" : [ModuleSubModel class]};
}
@end
