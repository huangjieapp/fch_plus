//
//  SHWechatCellSendAndReceiveView.m
//  mcr_sh_master
//
//  Created by Hjie on 2017/8/29.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHWechatCellSendAndReceiveView.h"

@implementation SHWechatCellSendAndReceiveView

- (void)updateCellWithDatas:(SHWechatTrackModel *)wechatTrackModel {
	
}

//泡泡文本
+ (UIView *)bubbleView:(SHWechatTrackModel *)wechatTrackModel withPosition:(int)position{
	
	/*
	 [cell.contentView addSubview:[SHWechatCellSendAndReceiveView bubbleView:self.trackArray[indexPath.row].C_TYPE_DD_NAME text:self.trackArray[indexPath.row].X_REMARK time:self.trackArray[indexPath.row].D_CREATE_TIME from:self.trackArray[indexPath.row].C_TYPE_DD_ID withPosition:20]]
	 */
	UIView *returnView = [[UIView alloc]initWithFrame:CGRectZero];
	//计算大小
	UIFont *font = [UIFont systemFontOfSize:14];
	CGSize size = [wechatTrackModel.X_REMARK sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
	
	CGSize typeSize = [wechatTrackModel.C_TYPE_DD_NAME sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
	
	CGSize timeSize = [wechatTrackModel.D_CREATE_TIME sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
	
	UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
	timeLabel.text = wechatTrackModel.D_CREATE_TIME;
	timeLabel.font = font;
	timeLabel.textColor = [UIColor blackColor];
	timeLabel.frame = CGRectMake(![wechatTrackModel.C_TYPE_DD_ID isEqualToString:@"A52100_C_TYPE_0004"] ? 10 : 220 - timeSize.width - 10, 0, timeSize.width, timeSize.height);
	[returnView addSubview:timeLabel];
	// build single chat bubble cell with given text
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
	contentView.backgroundColor = ![wechatTrackModel.C_TYPE_DD_ID isEqualToString:@"A52100_C_TYPE_0004"] ? DBColor(223, 223, 223) : DBColor(44, 165, 89);
	
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
	imageView.image = [UIImage imageNamed:@""];
	[contentView addSubview:imageView];
	
	UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, size.height)];
	textLabel.textColor = [UIColor blackColor];
	textLabel.text = imageView.image != nil ? [NSString stringWithFormat:@"%@|	 %@",wechatTrackModel.C_TYPE_DD_NAME,wechatTrackModel.X_REMARK] : [NSString stringWithFormat:@"%@|%@",wechatTrackModel.C_TYPE_DD_NAME,wechatTrackModel.X_REMARK];
	textLabel.font = [UIFont systemFontOfSize:14.0f];
	textLabel.numberOfLines = 0;
	[contentView addSubview:textLabel];
	
	imageView.frame = CGRectMake(typeSize.width + textLabel.frame.origin.x + 10, textLabel.frame.origin.y, 15, 15);
	
	contentView.frame = CGRectMake(0, timeSize.height, 220, textLabel.frame.size.height + 10);
	contentView.layer.cornerRadius = 5.0f;
	[returnView addSubview:contentView];
	
	returnView.frame = CGRectMake(![wechatTrackModel.C_TYPE_DD_ID isEqualToString:@"A52100_C_TYPE_0004"] ? position : KScreenWidth - position - 220, 0, 220, textLabel.frame.size.height + timeSize.height + 10);
	return returnView;
}

//泡泡文本
+ (UIView *)bubbleView:(NSString *)type text:(NSString *)text time:(NSString *)time from:(NSString *)fromSelf withPosition:(int)position{
	UIView *returnView = [[UIView alloc]initWithFrame:CGRectZero];
	//计算大小
	UIFont *font = [UIFont systemFontOfSize:14];
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
	
	CGSize typeSize = [type sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
	
	CGSize timeSize = [time sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
	
	UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
	timeLabel.text = time;
	timeLabel.font = font;
	timeLabel.textColor = [UIColor blackColor];
	timeLabel.frame = CGRectMake(![fromSelf isEqualToString:@"A52100_C_TYPE_0004"] ? 10 : 220 - timeSize.width - 10, 0, timeSize.width, timeSize.height);
	[returnView addSubview:timeLabel];
	// build single chat bubble cell with given text
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
	contentView.backgroundColor = ![fromSelf isEqualToString:@"A52100_C_TYPE_0004"] ? DBColor(223, 223, 223) : DBColor(44, 165, 89);
	
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
	imageView.image = [UIImage imageNamed:@""];
	[contentView addSubview:imageView];
	
	UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, size.height)];
	textLabel.textColor = [UIColor blackColor];
	textLabel.text = imageView.image != nil ? [NSString stringWithFormat:@"%@|	 %@",type,text] : [NSString stringWithFormat:@"%@|%@",type,text];
	textLabel.font = [UIFont systemFontOfSize:14.0f];
	textLabel.numberOfLines = 0;
	[contentView addSubview:textLabel];
	
	imageView.frame = CGRectMake(typeSize.width + textLabel.frame.origin.x + 10, textLabel.frame.origin.y, 15, 15);
	
	contentView.frame = CGRectMake(0, timeSize.height, 220, textLabel.frame.size.height + 10);
	contentView.layer.cornerRadius = 5.0f;
	[returnView addSubview:contentView];
	
	returnView.frame = CGRectMake(![fromSelf isEqualToString:@"A52100_C_TYPE_0004"] ? position : KScreenWidth - position - 220, 0, 220, textLabel.frame.size.height + timeSize.height + 10);
	return returnView;
}

//泡泡语音
+ (UIView *)yuyinView:(NSInteger)logntime from:(NSString *)fromSelf withIndexRow:(NSInteger)indexRow  withPosition:(int)position{
	
	//根据语音长度
	int yuyinwidth = 66;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.tag = indexRow;
	if([fromSelf isEqualToString:@"A52100_C_TYPE_0004"])
		button.frame =CGRectMake(320-position-yuyinwidth, 10, yuyinwidth, 54);
	else
		button.frame =CGRectMake(position, 10, yuyinwidth, 54);
	
	//image偏移量
	UIEdgeInsets imageInsert;
	imageInsert.top = -10;
	imageInsert.left = fromSelf.length > 0 ?button.frame.size.width/3:-button.frame.size.width/3;
	button.imageEdgeInsets = imageInsert;
	
	[button setImage:[UIImage imageNamed:fromSelf.length > 0?@"SenderVoiceNodePlaying":@"ReceiverVoiceNodePlaying"] forState:UIControlStateNormal];
	UIImage *backgroundImage = [UIImage imageNamed:fromSelf.length > 0?@"SenderVoiceNodeDownloading":@"ReceiverVoiceNodeDownloading"];
	backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
	[button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
	
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf.length > 0?-30:button.frame.size.width, 0, 30, button.frame.size.height)];
	label.text = [NSString stringWithFormat:@"%d''",logntime];
	label.textColor = [UIColor grayColor];
	label.font = [UIFont systemFontOfSize:13];
	label.textAlignment = NSTextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	[button addSubview:label];
	
	return button;
}

@end
