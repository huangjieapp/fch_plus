//
//  broadsideView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/17.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "broadsideView.h"

@interface broadsideView()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView*mainView;

@end
@implementation broadsideView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
       
        self.hidden=YES;
        self.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.6];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDismissView:)];
        tap.delegate=self;
        [self addGestureRecognizer:tap];
        
        
        _mainView=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/3, 0, KScreenWidth/3*2, KScreenHeight)];
        _mainView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_mainView];
       
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];

        
    }
    return self;
    
}


-(void)clickDismissView:(UIGestureRecognizer*)tap{
    self.hidden=YES;
    
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_mainView]) {
        return NO;
    }
    return YES;
}


@end
