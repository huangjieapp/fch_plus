//
//  RightPartView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/14.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "RightPartView.h"
#import "CommonDefine.h"

@interface RightPartView()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView*mainView;
@property(nonatomic,assign)UIView*superView;

@end
@implementation RightPartView

+(instancetype)creatPartViewWithDatas:(NSArray*)array andSuperView:(UIView*)superView{
    
    [superView setFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    RightPartView*Seview=[[super alloc]init];
    Seview.superView=superView;
    Seview.frame=CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT + 40, KScreenWidth, KScreenHeight - STATUS_AND_NAVIGATION_HEIGHT - 40);
    Seview.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.3];
    
    
    [Seview addMainView];
    
    return Seview;
}


-(void)addMainView{
//    self.userInteractionEnabled=YES;
    
    UIView*leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth/3, self.height)];
    leftView.backgroundColor=[UIColor clearColor];
    [self addSubview:leftView];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap)];
    tap.delegate=self;
    [leftView addGestureRecognizer:tap];

    
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/3, 0, KScreenWidth/3*2, self.height)];
    mainView.backgroundColor=[UIColor redColor];
    [self addSubview:mainView];
    self.mainView=mainView;
}


#pragma mark -- delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.mainView]) {
        return NO;
    }else{
        return YES;
    }
}


#pragma mark  --click
-(void)clickTap{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissRightPart" object:nil];
    
    
}


@end
