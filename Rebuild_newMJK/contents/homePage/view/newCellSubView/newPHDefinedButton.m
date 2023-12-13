//
//  newPHDefinedButton.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/2.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "newPHDefinedButton.h"

@implementation newPHDefinedButton

+(instancetype)newPHDefinedButton{
    
    newPHDefinedButton*button=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    button.frame=CGRectMake(0, 0, 60, 30);
    
    return button;
}

@end
