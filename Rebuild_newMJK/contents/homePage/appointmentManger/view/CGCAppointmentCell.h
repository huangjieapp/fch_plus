//
//  CGCAppointmentCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGCAppointmentModel;
@class CGCOrderDetailModel;
@class MJKCarSourceSubModel;

@interface CGCAppointmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftLayout;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *starImg;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UIImageView *sexImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@property (weak, nonatomic) IBOutlet UILabel *telLab;

@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;


@property (weak, nonatomic) IBOutlet UILabel *iconLab;

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (nonatomic, strong) CGCOrderDetailModel *model;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)reloadCellWithModel:(CGCAppointmentModel *)model;

- (void)reloadOrderCellWithModel:(CGCOrderDetailModel *)model;

/** MJKCarSourceSubModel*/
@property (nonatomic, strong) MJKCarSourceSubModel *carModel;

@end
