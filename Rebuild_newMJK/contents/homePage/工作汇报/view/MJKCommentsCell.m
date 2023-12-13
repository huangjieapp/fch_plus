//
//  MJKCommentsCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKCommentsCell.h"

@implementation MJKCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.cornerRadius = 30.f;
	self.headImageView.layer.masksToBounds = YES;
}

- (void)setModel:(MJKCommentsListModel *)model {
	_model = model;
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL]];
	self.nameLabel.text = model.C_CREATOR_ROLENAME;
	self.contentLabel.text = model.X_REMARK;
	self.timeLabel.text = model.D_CREATE_TIME;
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKCommentsCell";
	MJKCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		//		if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		//			[cell setLayoutMargins:UIEdgeInsetsZero];
		//		}
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
