//
//  CGCAlreadyPayCell.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCAlreadyPayModel;
@interface CGCAlreadyPayCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (weak, nonatomic) IBOutlet UILabel *countLab;


@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)reloadCellWithModel:(CGCAlreadyPayModel *)model;

@end
