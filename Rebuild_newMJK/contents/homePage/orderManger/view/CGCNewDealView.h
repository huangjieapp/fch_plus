//
//  CGCNewDealView.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/23.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGCNewDealView : UIView
@property (weak, nonatomic) IBOutlet UILabel *xyCardLab;

@property (weak, nonatomic) IBOutlet UITextField *remarksTextField;

@property (weak, nonatomic) IBOutlet UITextField *moneyLab;

@property (weak, nonatomic) IBOutlet UIView *scanBgView;
@property (weak, nonatomic) IBOutlet UIButton *zfBtn;

@property (weak, nonatomic) IBOutlet UIButton *xyBtn;

@property (weak, nonatomic) IBOutlet UIButton *wxBtn;

@property (weak, nonatomic) IBOutlet UIButton *xjBtn;

@property (weak, nonatomic) IBOutlet UILabel *payTitleLab;

@property (weak, nonatomic) IBOutlet UIView *payBgView;

@property (weak, nonatomic) IBOutlet UILabel *xjClueLab;

@property (weak, nonatomic) IBOutlet UIImageView *scanImg;

@property (weak, nonatomic) IBOutlet UILabel *scanClueLab;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;



@end
