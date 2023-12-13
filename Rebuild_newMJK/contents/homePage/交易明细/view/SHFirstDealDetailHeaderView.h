//
//  SHFirstDealDetailHeaderView.h
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/15.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHFirstDealModel.h"


@interface SHFirstDealDetailHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property(nonatomic,strong)SHFirstDealModel*model;

@end
