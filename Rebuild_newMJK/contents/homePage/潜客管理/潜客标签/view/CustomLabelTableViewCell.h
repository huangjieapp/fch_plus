//
//  CustomLabelTableViewCell.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/4.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabelModel.h"

@interface CustomLabelTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel*titleLabel;   //标题  最上方

@property(nonatomic,strong)NSArray*labelArray;  //所有label的数组  这个是model里面的值


//model 传过去 和是否是新增 yes 是新增  no是移除
@property(nonatomic,copy)void(^getclickButtonBlock)(CustomLabelModel*model,BOOL isSelected);
+(CGFloat)cellHeightWithArray:(NSArray*)labelArray;



@end
