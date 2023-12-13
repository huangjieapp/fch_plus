//
//  CustomLabelHeaderView.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/4.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLabelHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong)NSMutableArray*allLabelArray;   //这里面也是model


+(CGFloat)headerHeight:(NSArray*)array;


@end
