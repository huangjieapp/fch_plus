//
//  CustomLabelModel.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/4.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomLabelModel : NSObject

@property(nonatomic,strong)UIColor*currentColor;
@property(nonatomic,strong)NSString*title;
@property(nonatomic,assign)BOOL isSelected;   //保存选中状态

@end
