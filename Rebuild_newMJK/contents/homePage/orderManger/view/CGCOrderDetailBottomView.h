//
//  CGCOrderDetailBottomView.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGCOrderDetailBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *payBtn;


@property (weak, nonatomic) IBOutlet UIButton *updateBtn;


@property (weak, nonatomic) IBOutlet UILabel *totalpricesLab;


@property (weak, nonatomic) IBOutlet UILabel *actualamountLab;


@property (weak, nonatomic) IBOutlet UILabel *priceNameLab;

@property (weak, nonatomic) IBOutlet UILabel *middleLab;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payWidth;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *detailTotalLab;

@property (weak, nonatomic) IBOutlet UILabel *detailLabWeiKLab;

@end
