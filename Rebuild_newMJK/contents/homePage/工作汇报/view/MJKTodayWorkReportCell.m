//
//  MJKTodayWorkReportCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKTodayWorkReportCell.h"
#import "MJKWorkReportDetailModel.h"

@implementation MJKTodayWorkReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.labelLayout.constant = KScreenWidth - 20;
}

- (void)setModel:(MJKWorkReportDetailModel *)model {
	_model = model;
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@ %@",model.C_TYPE_DD_NAME, model.B_TOTAL, model.UNIT]];
	[attributedString setAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle), NSForegroundColorAttributeName : KNaviColor} range:NSMakeRange(attributedString.length - model.UNIT.length - 1 - model.B_TOTAL.length, model.B_TOTAL.length)];
	self.todayWorkLabel.attributedText = attributedString;
    self.countLabel.text = [NSString stringWithFormat:@"%@%@",model.B_TOTAL_JH,model.UNIT];
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKTodayWorkReportCell";
	MJKTodayWorkReportCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
