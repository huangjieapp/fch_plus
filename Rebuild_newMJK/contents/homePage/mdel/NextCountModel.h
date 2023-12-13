//
//  NextCountModel.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/9.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "subDicNextCountModel.h"

@interface NextCountModel : MJKBaseModel

@property(nonatomic,strong)NSString*TYPE;
@property(nonatomic,strong)NSArray*content;   //这个是个数组 里面都是字典

@end
