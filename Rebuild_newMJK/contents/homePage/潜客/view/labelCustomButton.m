//
//  labelCustomButton.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "labelCustomButton.h"

@implementation labelCustomButton

-(instancetype)init{
    self=[super init];
    if (self) {
        
       
        self.layer.borderColor=[UIColor redColor].CGColor;
        self.layer.borderWidth=1;
        self.layer.cornerRadius=5;
        self.layer.masksToBounds=YES;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
//        self.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 5);
        self.titleLabel.font=[UIFont systemFontOfSize:14];
        
        
//        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
//        
//        [self setBackgroundImage:[UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
 
        
        
    }
    
    
    
    return self;
}

@end
