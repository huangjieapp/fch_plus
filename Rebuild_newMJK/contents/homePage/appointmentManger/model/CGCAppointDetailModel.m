//
//  CGCAppointDetailModel.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/30.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCAppointDetailModel.h"
#import "CGCAppointmentModel.h"


@implementation CGCAppointDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [CGCAppointmentModel class]
            
             };
}
  
    
//+ (NSArray *)modelPropertyWhitelist {
//    return @[@"content"];
//}
//   

@end
