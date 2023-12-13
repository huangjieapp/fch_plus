//
//  MJKWorkReportEmployeeCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKWorkReportEmployeeCell.h"

@implementation MJKWorkReportEmployeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.headImageView.layer.cornerRadius = 25.f;
	self.headImageView.layer.masksToBounds = YES;
}

- (void)setModel:(MJKWorkReportListModel *)model {
	_model = model;
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"logo-images"]];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@  %@",model.USERNAME, model.D_CREATE_TIME]];
	[attributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} range:NSMakeRange(attributedString.length - model.D_CREATE_TIME.length, model.D_CREATE_TIME.length)];
	self.employeeLabel.attributedText = attributedString;
	if (model.D_LASTUPDATE_TIME.length > 0) {
		self.updateTimeLabel.text = [NSString stringWithFormat:@"日报更新于%@",model.D_LASTUPDATE_TIME];
		self.updateTimeLabel.hidden = NO;
	} else {
		self.updateTimeLabel.hidden = YES;
	}
	
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKWorkReportEmployeeCell";
	MJKWorkReportEmployeeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
