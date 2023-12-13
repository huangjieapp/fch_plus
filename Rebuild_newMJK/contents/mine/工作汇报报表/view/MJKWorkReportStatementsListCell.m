//
//  MJKWorkReportStatementsListCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/7.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKWorkReportStatementsListCell.h"

@implementation MJKWorkReportStatementsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKWorkReportStatementsListModel *)model {
	_model = model;
	self.titleLabel.text = model.C_STATUS_DD_NAME;
	self.countLabel.text = [NSString stringWithFormat:@"%@人",model.COUNT];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKWorkReportStatementsListCell";
	MJKWorkReportStatementsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
