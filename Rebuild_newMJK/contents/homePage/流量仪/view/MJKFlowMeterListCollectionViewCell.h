//
//  MJKFlowMeterListCollectionViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKFlowMeterSubSecondModel.h"

typedef void(^ChooseMoreBlock)(MJKFlowMeterSubSecondModel *model);

@interface MJKFlowMeterListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *arraiveInfoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseMoreImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *staffImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) MJKFlowMeterSubSecondModel *model;
@property (weak, nonatomic) IBOutlet UIButton *chooseMoreButton;
@property (nonatomic, assign) BOOL isMore;

@property (nonatomic, copy) ChooseMoreBlock chooseMoreBlock;


+ (instancetype)cellWithTableView:(UICollectionView *)tableView andIndexPath:(NSIndexPath *)indexPath;


@end
