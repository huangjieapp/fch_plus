//
//  MJKPKSheetModel.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKPKSheetModel.h"
#import "MJKPKSheetSubModel.h"

@implementation MJKPKSheetModel

+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
    
    return @{@"MEMBER":MJKPKSheetSubModel.class}
    ;
    
}

+ (NSDictionary *)mj_objectClassInArray {
	return @{@"MEMBER" : @"MJKPKSheetSubModel"};
}

@end
