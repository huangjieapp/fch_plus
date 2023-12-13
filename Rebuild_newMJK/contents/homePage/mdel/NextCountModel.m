//
//  NextCountModel.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/9.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "NextCountModel.h"


@implementation NextCountModel

//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
    
    return @{@"content":subDicNextCountModel.class}
    ;
    
}

@end
