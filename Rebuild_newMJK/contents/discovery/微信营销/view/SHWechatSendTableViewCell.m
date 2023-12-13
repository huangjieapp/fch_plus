//
//  SHWechatSendTableViewCell.m
//  mcr_sh_master
//
//  Created by Hjie on 2017/8/24.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHWechatSendTableViewCell.h"

#define textFont 14.0f
/// 颜色
#define COLOR_RGB(rgb) [UIColor colorWithRed:((rgb & 0xff0000) >> 16) / 255.0 green:((rgb & 0xff00) >> 8) / 255.0 blue:(rgb & 0xff) / 255.0 alpha:1]
#define COLOR_RGB_ALPHA(rgb, alpha) [UIColor colorWithRed:((rgb & 0xff0000) >> 16) / 255.0 green:((rgb & 0xff00) >> 8) / 255.0 blue:(rgb & 0xff) / 255.0 alpha:alpha]
/** 1    背景色    - 浅灰 */
#define kBackgroundColor COLOR_RGB(0xefeff4)

@implementation SHWechatSendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)init {
	if (self = [super init]) {
//		[self initCell];
	}
	return self;
}

- (void)initReceiveCellWithPhoto:(NSString *)image andContent:(NSString *)str andType:(NSString *)type andTime:(NSString *)time {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	//接收到的时间
	UILabel *receiveTimeLabel = [[UILabel alloc]init];
	self.receiveTimeLabel = receiveTimeLabel;
	[self.contentView addSubview:receiveTimeLabel];
	
	//接受到的消息的view
	UIView *receiveView = [[UIView alloc]init];
	self.receiveView = receiveView;
	[self.contentView addSubview:receiveView];
	
	//接受到的消息的左侧label
	UILabel *receiveLeftLabel = [[UILabel alloc]init];
	self.receiveLeftLabel = receiveLeftLabel;
	[receiveView addSubview:receiveLeftLabel];
	//接受到的消息的label
	UILabel *receiveLabel = [[UILabel alloc]init];
	self.receiveLabel = receiveLabel;
	[receiveView addSubview:receiveLabel];
	
	
	
	[receiveTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(6);
		make.left.mas_equalTo(10);
		make.width.mas_greaterThanOrEqualTo(110);
		make.height.mas_equalTo(18);
	}];
	receiveTimeLabel.numberOfLines = 1;
	receiveTimeLabel.text = time;
	receiveTimeLabel.font = [UIFont systemFontOfSize:textFont];
	
	[receiveView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(receiveTimeLabel.mas_left);
		make.top.mas_equalTo(receiveTimeLabel.mas_bottom).mas_equalTo(6);
		make.width.mas_equalTo(KScreenWidth / 3 * 2);
		make.bottom.mas_equalTo(-6);
	}];
	receiveView.backgroundColor = DBColor(223, 223, 223);
	receiveView.layer.cornerRadius = 5.0f;
	
	[receiveLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(6);
		make.width.mas_equalTo(60);
		make.centerY.mas_equalTo(receiveView.mas_centerY);
	}];
	receiveLeftLabel.text = type;
	receiveLeftLabel.font = [UIFont systemFontOfSize:textFont];
	//分割线
	UIView *sepView = [[UIView alloc]init];
	[receiveView addSubview:sepView];
	[sepView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(receiveLeftLabel.mas_right).mas_equalTo(6);
		make.width.mas_equalTo(1);
		make.top.mas_equalTo(6);
		make.bottom.mas_equalTo(0);
	}];
	sepView.backgroundColor = [UIColor grayColor];
	//如果有图片
	UIImageView *imageView = [[UIImageView alloc]init];
	self.receiveImageView = imageView;
	[receiveView addSubview:imageView];
	imageView.image = [UIImage imageNamed:image];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		if (imageView.image) {
			make.left.mas_equalTo(sepView.mas_right).mas_equalTo(6);
			make.centerY.mas_equalTo(0);
			make.width.height.mas_equalTo(20);
		} else {
			make.left.mas_equalTo(sepView.mas_right).mas_equalTo(0);
		}
	}];

	[receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(imageView.mas_right).mas_equalTo(6);
		make.top.mas_equalTo(0);
		make.right.mas_equalTo(receiveView.mas_right);
		make.bottom.mas_equalTo(0);
	}];
	receiveLabel.numberOfLines = 0;
	receiveLabel.text = str;
	receiveLabel.font = [UIFont systemFontOfSize:textFont];
	receiveLabel.backgroundColor = [UIColor clearColor];
	
}

- (void)initSendCellWithPhoto:(NSString *)image andContent:(NSString *)str andType:(NSString *)type andTime:(NSString *)time {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	//接收到的时间
	UILabel *receiveTimeLabel = [[UILabel alloc]init];
	self.receiveTimeLabel = receiveTimeLabel;
	[self.contentView addSubview:receiveTimeLabel];
	
	//接受到的消息的view
	UIView *receiveView = [[UIView alloc]init];
	self.receiveView = receiveView;
	[self.contentView addSubview:receiveView];
	
	//接受到的消息的左侧label
	UILabel *receiveLeftLabel = [[UILabel alloc]init];
	self.receiveLeftLabel = receiveLeftLabel;
	[receiveView addSubview:receiveLeftLabel];
	//接受到的消息的label
	UILabel *receiveLabel = [[UILabel alloc]init];
	self.receiveLabel = receiveLabel;
	[receiveView addSubview:receiveLabel];
	
	
	
	[receiveTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(6);
		make.right.mas_equalTo(-10);
		make.width.mas_greaterThanOrEqualTo(110);
		make.height.mas_equalTo(18);
	}];
	receiveTimeLabel.numberOfLines = 1;
	receiveTimeLabel.text = time;
	receiveTimeLabel.font = [UIFont systemFontOfSize:textFont];
	
	[receiveView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(receiveTimeLabel.mas_right);
		make.top.mas_equalTo(receiveTimeLabel.mas_bottom).mas_equalTo(6);
		make.width.mas_equalTo(KScreenWidth / 3 * 2);
		make.bottom.mas_equalTo(-6);
	}];
	receiveView.backgroundColor = DBColor(223, 223, 223);
	receiveView.layer.cornerRadius = 5.0f;
	
	[receiveLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(6);
		make.width.mas_equalTo(60);
		make.centerY.mas_equalTo(receiveView.mas_centerY);
	}];
	receiveLeftLabel.text = type;
	receiveLeftLabel.font = [UIFont systemFontOfSize:textFont];
	//分割线
	UIView *sepView = [[UIView alloc]init];
	[receiveView addSubview:sepView];
	[sepView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(receiveLeftLabel.mas_right).mas_equalTo(6);
		make.width.mas_equalTo(1);
		make.top.mas_equalTo(6);
		make.bottom.mas_equalTo(0);
	}];
	sepView.backgroundColor = [UIColor grayColor];
	//如果有图片
	UIImageView *imageView = [[UIImageView alloc]init];
	self.receiveImageView = imageView;
	[receiveView addSubview:imageView];
	imageView.image = [UIImage imageNamed:image];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		if (imageView.image) {
			make.left.mas_equalTo(sepView.mas_right).mas_equalTo(6);
			make.centerY.mas_equalTo(0);
			make.width.height.mas_equalTo(20);
		} else {
			make.left.mas_equalTo(sepView.mas_right).mas_equalTo(0);
		}
	}];
	
	[receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(imageView.mas_right).mas_equalTo(6);
		make.top.mas_equalTo(0);
		make.right.mas_equalTo(receiveView.mas_right);
		make.bottom.mas_equalTo(0);
	}];
	receiveLabel.numberOfLines = 0;
	receiveLabel.text = str;
	receiveLabel.font = [UIFont systemFontOfSize:textFont];
	receiveLabel.backgroundColor = [UIColor clearColor];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
