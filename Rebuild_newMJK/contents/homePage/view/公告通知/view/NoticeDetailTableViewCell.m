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
@property (weak, nonatomic) IBOutlet UIView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

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

- (IBAction)countButtonAction:(UIButton *)sender {
}

- (IBAction)readListButtonAction:(UIButton *)sender {
	if (self.readerListBlock) {
		self.readerListBlock();
	}
}

-(void)getValue:(NoticeInfoModel*)model{
    _titleLabel.text=model.C_TITLE;
//    _contentLabel.text=model.X_SHARE_CONTENT;
	_contentLabel.hidden = YES;
    _timeLabel.text=model.D_CREATE_TIME;
    _nameLabel.text=model.C_CREATOR_ROLENAME;
	self.countLabel.text = [NSString stringWithFormat:@"%ld",model.readerCount];
	for (int i = 0; i < model.readerHeads.count; i++) {
		if (i > 7) {
			return;
		}
		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(55 + (i * 25), 5, 20, 20)];
		imageView.layer.cornerRadius = 10;
		imageView.layer.masksToBounds = YES;
		[imageView sd_setImageWithURL:[NSURL URLWithString:model.readerHeads[i]]];
		[self.headImageView addSubview:imageView];
	}

}


@end
