//
//  SHWechatListModel.h
//  mcr_sh_master
//
//  Created by Hjie on 2017/8/25.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHWechatListSubModel.h"

@interface SHWechatListModel : MJKBaseModel

@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSArray *content;

@end
