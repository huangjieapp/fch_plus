//
//  MJKOnlineMainTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/19.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKOnlineMainTableViewCell.h"

@implementation MJKOnlineMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.cornerRadius = 5.0f;
}

- (void)setModel:(MJKOnlineMainHallSubModel *)model {
	self.placeLabel.text = model.C_POSITION;
	self.headImageView.image = model.C_PICURL.length > 0 ? [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.C_PICURL]]] : [UIImage imageNamed:@"logo-头像.png"];
	if ([model.status isEqualToString:@"0"]) {
		self.statusLabel.text = @"离线";
	} else if ([model.status isEqualToString:@"1"]) {
		self.statusLabel.text = @"在线";
		self.statusLabel.textColor = DBColor(114, 218, 73);
	}
	
	self.eyesLabel.text = model.X_REMARK;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKOnlineMainTableViewCell";
	MJKOnlineMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
