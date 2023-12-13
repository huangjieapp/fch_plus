//
//  FunnelCustomButton.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "FunnelCustomButton.h"

@implementation FunnelCustomButton

-(instancetype)init{
    self=[super init];
    if (self) {
        
        
//        self.layer.borderColor=[UIColor grayColor].CGColor;
//        self.layer.borderWidth=1;
        self.layer.cornerRadius=5;
        self.layer.masksToBounds=YES;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont systemFontOfSize:14];
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self setBackgroundImage:[UIImage imageWithColor:DBColor(229, 229, 229) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:KNaviColor size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        
        
        
        //        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        //        [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        //
        //        [self setBackgroundImage:[UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        
        
        
    }
    
    
    
    return self;
}


@end
