//
//  SHWechatMarketTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/31.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHWechatMarketTableViewCell.h"



@implementation SHWechatMarketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.starButton.enabled=NO;
    self.eyeButton.enabled=NO;
//    self.topStatusLabel.layer.borderWidth=1;
//    self.topStatusLabel.layer.borderColor=[UIColor grayColor].CGColor;
	self.mainImageView.layer.cornerRadius = 5.0f;
}

- (void)updateCellWithData:(SHWechatListSubModel *)wechatListSubModel {
	self.titleLabel.text = wechatListSubModel.C_NAME;
	self.topStatusLabel.text = wechatListSubModel.C_STATUS_DD_NAME;
	if ([wechatListSubModel.C_STATUS_DD_NAME isEqualToString:@"未处理"]) {
		self.topStatusLabel.textColor = DBColor(252, 126, 111);
	} else if ([wechatListSubModel.C_STATUS_DD_NAME isEqualToString:@"已新增"]) {
		self.topStatusLabel.textColor = DBColor(129,222,92);
	} else if ([wechatListSubModel.C_STATUS_DD_NAME isEqualToString:@"已关联"]) {
		self.topStatusLabel.textColor = DBColor(75,176,196);
	} else if ([wechatListSubModel.C_STATUS_DD_NAME isEqualToString:@"未留档"] ) {
		self.topStatusLabel.textColor = DBColor(153,153,153);
	}
	self.mainImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:wechatListSubModel.C_HEADIMGURL]]];
	self.bottomStatusLabel.text =wechatListSubModel.C_OWNER_ROLENAME;
	if ([wechatListSubModel.C_CLZT isEqualToString:@"1"]) {
		//		[self.eyeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
		self.eyeButton.hidden = YES;
	} else {
		self.eyeButton.hidden = NO;
		[self.eyeButton setBackgroundImage:[UIImage imageNamed:@"有未读消息.png"] forState:UIControlStateNormal];
	}
	if ([wechatListSubModel.C_STAR isEqualToString:@"1"]) {
		
		[self.starButton setBackgroundImage:[UIImage imageNamed:@"星标.png"] forState:UIControlStateNormal];
	} else {
		[self.starButton setBackgroundImage:[UIImage imageNamed:@"未星标.png"] forState:UIControlStateNormal];
	}
	if ([wechatListSubModel.C_GENDER_DD_NAME isEqualToString:@"男"]) {
		self.sexImageView.image = [UIImage imageNamed:@"iv_man.png"];
	} else {
		self.sexImageView.image = [UIImage imageNamed:@"iv_women.png"];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

@end
