//
//  SHMineTopTableViewCell.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/6.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHMineTopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *qrcodeButton;


@property(nonatomic,assign)BOOL refresh;

@end
