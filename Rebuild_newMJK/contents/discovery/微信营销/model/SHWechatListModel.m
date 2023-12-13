//
//  SHWechatListModel.m
//  mcr_sh_master
//
//  Created by Hjie on 2017/8/25.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHWechatListModel.h"

@implementation SHWechatListModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":SHWechatListSubModel.class}
	;
	
}
@end



