//
//  CGCOrderdetailHead.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGCOrderdetailHead : UIView
@property (weak, nonatomic) IBOutlet UIButton *cardButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *iconName;
@property (weak, nonatomic) IBOutlet UILabel *createTimeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *finshNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UIImageView *sexImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *workLab;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;

@property (weak, nonatomic) IBOutlet UILabel *payTime;

@property (weak, nonatomic) IBOutlet UIButton *telBtn;

@property (weak, nonatomic) IBOutlet UIButton *mesBtn;

@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;

@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@property (nonatomic, copy) void(^editBlock)(void);


@end
