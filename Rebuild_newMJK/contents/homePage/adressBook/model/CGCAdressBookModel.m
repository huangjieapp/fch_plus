//
//  CGCAdressBookModel.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCAdressBookModel.h"
#import "CGCAdressBookDetailModel.h"


@implementation CGCAdressBookModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"array" : [CGCAdressBookDetailModel class]
             
             };
}

@end
