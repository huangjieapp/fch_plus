//
//  CGCGoodsDetailCell.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/25.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  CodeShoppingModel;
@interface CGCGoodsDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (weak, nonatomic) IBOutlet UILabel *proLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *minsBtn;

@property (weak, nonatomic) IBOutlet UILabel *geshuLab;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)reloadCellWithModel:(CodeShoppingModel *)model;
@end
