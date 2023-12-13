//
//  SHBoardView.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/2.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBoardView : UIView

+(instancetype)boardView;

@property (weak, nonatomic) IBOutlet UILabel *leftTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftTopToday;
@property (weak, nonatomic) IBOutlet UILabel *leftTopMonth;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomToday;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomMonth;

@property (weak, nonatomic) IBOutlet UILabel *rightTopToday;
@property (weak, nonatomic) IBOutlet UILabel *rightTopMonth;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomToday;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomMonth;

@property (weak, nonatomic) IBOutlet UIButton *topJRBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomJRBtn;
@property (weak, nonatomic) IBOutlet UIButton *topMonBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomMonBtn;

@end
