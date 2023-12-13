//
//  MJKClueListViewModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MJKClueListViewModel.h"

@implementation MJKClueListViewModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKClueListSubModel.class, @"data":MJKClueListSubModel.class}
	;
	
}
@end
