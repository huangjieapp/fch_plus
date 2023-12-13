//
//  SHNewHomePageFirstTableViewCell.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/2.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopCountModel.h"
#import "NextCountModel.h"
#import "MJKJXModel.h"

@interface SHNewHomePageFirstTableViewCell : UITableViewCell

-(void)getTopValue:(MJKJXModel*)model andNextValue:(NSMutableArray*)mtArray;
//-(void)getTopValue:(TopCountModel*)model  andNextValue:(NSMutableArray*)mtArray;
+(CGFloat)getCellHeight;
@end
