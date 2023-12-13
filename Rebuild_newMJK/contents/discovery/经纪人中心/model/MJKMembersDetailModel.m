//
//  MJKMembersDetailModel.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/11/30.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKMembersDetailModel.h"
#import "CustomLabelModel.h"

@implementation MJKMembersDetailModel
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
    
    return @{@"labelsList":CustomLabelModel.class}
    ;
    
}
@end
