//
//  SHDealDetailHeaderView.h
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/15.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHDealDetailHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

@property (weak, nonatomic) IBOutlet UIButton *manualAdd;
@property (weak, nonatomic) IBOutlet UIButton *forceChange;

@property(nonatomic,copy)void(^clickAddBlock)();
@property(nonatomic,copy)void(^clickChangeBlock)();

@end
