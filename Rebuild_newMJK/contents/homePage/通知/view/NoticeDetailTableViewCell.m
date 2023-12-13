//
//  NoticeDetailTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/22.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "NoticeDetailTableViewCell.h"

@interface NoticeDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation NoticeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    // Configure the view for the selected state
}



-(void)getValue:(NoticeInfoModel*)model{
    _titleLabel.text=model.C_TITLE;
    _contentLabel.text=model.X_SHARE_CONTENT;
    _timeLabel.text=model.D_CREATE_TIME;
    _nameLabel.text=model.C_CREATOR_ROLENAME;
    

}


@end
