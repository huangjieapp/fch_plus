//
//  MJKAttendanceCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/11.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAttendanceCell.h"

@implementation MJKAttendanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKAttendanceModel *)model {
	_model = model;
	self.nameLabel.text = model.C_NAME;
	
	if (model.isSelected == YES) {
		self.selectImageView.image = [UIImage imageNamed:@"打钩"];
	} else {
		self.selectImageView.image = [UIImage imageNamed:@"未打钩"];
	}
	
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKAttendanceCell";
	MJKAttendanceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
