//
//  MJKClueListMainModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MJKClueListMainModel.h"

@implementation MJKClueListMainModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKClueListMainFirstSubModel.class}
	;
	
}
@end
