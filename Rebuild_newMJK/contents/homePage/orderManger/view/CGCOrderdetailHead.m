//
//  CGCOrderdetailHead.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CGCOrderdetailHead.h"//订单详情里的头部用户信息
#import "KSPhotoBrowser.h"

@implementation CGCOrderdetailHead


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.headImg.userInteractionEnabled=YES;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickScaleImg)];
    [self.headImg addGestureRecognizer:tap];
    
    
}


-(void)clickScaleImg{
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:self.headImg image:self.headImg.image];
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
    [browser showFromViewController:[DBTools getSuperViewWithsubView:self]];

    
    
}
- (IBAction)editButtonAction:(UIButton *)sender {
	if (self.editBlock) {
		self.editBlock();
	}
}

@end
