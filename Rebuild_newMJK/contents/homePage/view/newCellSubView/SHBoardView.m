//
//  SHBoardView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/2.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHBoardView.h"

@implementation SHBoardView

+(instancetype)boardView{
    SHBoardView*boardView=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    boardView.frame=CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(75));
    
    if (isiPhone5) {
        UILabel*label0=[boardView viewWithTag:222];
        label0.font=[UIFont systemFontOfSize:10];
        
        UILabel*label1=[boardView viewWithTag:223];
        label1.font=[UIFont systemFontOfSize:10];
    }
    
    
    return boardView;
    
}


@end
