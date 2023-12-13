//
//  CGCVerListCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/7/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

@class PointorderModel;
@class CGCCustomModel;
#import <UIKit/UIKit.h>


@interface CGCVerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (weak, nonatomic) IBOutlet UILabel *storeLab;

@property (weak, nonatomic) IBOutlet UIButton *statusbtn;

@property (weak, nonatomic) IBOutlet UILabel *staLab;

@property (weak, nonatomic) IBOutlet UIImageView *sexImg;


-(void)verificationCellReloadCell:(PointorderModel *)model;

-(void)brokerCellWithModel:(CGCCustomModel *)model;

+ (instancetype)cellWithTableView:(UITableView *)tableView ;

@end
