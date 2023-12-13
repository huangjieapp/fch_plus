//
//  CustomerSourceChannelModel.m
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import "CustomerSourceChannelModel.h"

@implementation CustomerSourceChannelSubModel

@end

@implementation CustomerSourceChannelModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list": [CustomerSourceChannelSubModel class]};
}
@end
