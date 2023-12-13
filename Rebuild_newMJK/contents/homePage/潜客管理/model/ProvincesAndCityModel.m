//
//  ProvincesAndCityModel.m
//  match5.0
//
//  Created by huangjie on 2023/2/9.
//

#import "ProvincesAndCityModel.h"

@implementation ProvincesAndCityModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"children" : @"ProvincesAndCityModel"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"C_ID" : @"id"};
}
@end
