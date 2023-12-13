//
//  MJKYesterdayWorkReportCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKYesterdayWorkReportCell.h"

@implementation MJKYesterdayWorkReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.labelLayout.constant = KScreenWidth - 20;
	self.yesterdayWorkLabel.numberOfLines = 0;
}
//汇报列表
- (void)setModel:(MJKWorkReportListModel *)model {
	_model = model;
	if (self.indexPath.section == 1 && self.indexPath.row == 0) {
		self.yesterdayWorkLabel.text = model.X_ZRPLAN;
	} else if ((self.indexPath.section == 3 && self.indexPath.row == 0)) {
		self.yesterdayWorkLabel.text = model.X_MRPLAN.length > 0 ? [NSString stringWithFormat:@"备注:\n%@",model.X_MRPLAN] : @"暂无明日计划";
	} else {
		self.yesterdayWorkLabel.text = [NSString stringWithFormat:@"备注:%@",model.X_REMARK];
	}
}


#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKYesterdayWorkReportCell";
	MJKYesterdayWorkReportCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		//		if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		//			[cell setLayoutMargins:UIEdgeInsetsZero];
		//		}
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
