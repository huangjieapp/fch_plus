//
//  CGCTalkModel.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCTalkModel.h"
#import "CGCTalkDetailModel.h"
@implementation CGCTalkModel

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{


}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"array" : [CGCTalkDetailModel class]
             
             };
}

@end
