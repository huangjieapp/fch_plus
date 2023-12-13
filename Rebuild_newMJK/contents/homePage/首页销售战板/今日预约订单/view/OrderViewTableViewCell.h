//
//  OrderViewTableViewCell.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/17.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;

@end
