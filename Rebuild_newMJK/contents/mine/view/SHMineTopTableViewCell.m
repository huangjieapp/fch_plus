//
//  SHMineTopTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/6.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHMineTopTableViewCell.h"

@implementation SHMineTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _myImageView.contentMode=UIViewContentModeScaleAspectFill;
    _myImageView.layer.cornerRadius=6;
    _myImageView.layer.masksToBounds=YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark  --set
-(void)setRefresh:(BOOL)refresh{
    _refresh=refresh;
    
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:[NewUserSession instance].user.avatar] placeholderImage:[UIImage imageNamed:@"设置头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.titleLabel.text=[NewUserSession instance].user.nickName;
//    self.descriptionLabel.text=[NSString stringWithFormat:@"%@账号:%@",[NewUserSession instance].C_ABBREVATION,[NewUserSession instance].user.nickName];
    
    self.descriptionLabel.text=[NSString stringWithFormat:@"账号:%@",[NewUserSession instance].user.nickName];

    
    
}

@end
