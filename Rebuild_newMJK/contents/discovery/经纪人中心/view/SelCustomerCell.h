//
//  SelCustomerCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/6/1.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SingleIntegarModel;

@interface SelCustomerCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (weak, nonatomic) IBOutlet UILabel *blLab;

@property (weak, nonatomic) IBOutlet UILabel *jfLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *baobeiLab;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)reloadCellWithModel:(SingleIntegarModel *)model;
@end
