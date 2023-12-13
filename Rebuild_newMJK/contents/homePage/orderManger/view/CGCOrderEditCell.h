//
//  CGCOrderEditCell.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGCOrderEditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *iconNameLab;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UIImageView *sexImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIButton *telBtn;

@property (weak, nonatomic) IBOutlet UIButton *mesBtn;

@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@end
