//
//  SHWechatMainListModel.m
//  mcr_sh_master
//
//  Created by Hjie on 2017/8/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "SHWechatMainListModel.h"

@implementation SHWechatMainListModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":SHWechatListModel.class}
	;
	
}
@end
