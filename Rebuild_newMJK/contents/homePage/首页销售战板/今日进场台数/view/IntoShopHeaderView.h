//
//  IntoShopHeaderView.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/17.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntoShopHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end
