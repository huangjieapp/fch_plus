//
//  MJKAddMRPlanCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/23.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKAddMRPlanCell.h"
#import "MJKWorkReportDetailModel.h"

@implementation MJKAddMRPlanCell

- (void)awakeFromNib {
	[super awakeFromNib];
	// Initialization code
	self.labelLayout.constant = KScreenWidth - 20;
	[self.countTF addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setModel:(MJKWorkReportDetailModel *)model {
	_model = model;
	self.todayWorkLabel.text = model.C_TYPE_DD_NAME;
	self.countTF.text = model.B_TOTAL_JH_MR;
    self.monthLabel.text = model.I_TARGETNUMBER;
    self.completeLabel.text = model.B_TOTAL_BY;

}

- (void)changeText:(UITextField *)textTF {
	self.model.B_TOTAL_JH_MR = textTF.text;
}
- (IBAction)addButtonAction:(UIButton *)sender {
	NSInteger count = [self.model.B_TOTAL_JH_MR integerValue];
	count++;
    self.model.B_TOTAL_JH_MR = [NSString stringWithFormat:@"%ld",(long)count];
	self.countTF.text = self.model.B_TOTAL_JH_MR;
}
- (IBAction)minButtonAction:(UIButton *)sender {
	NSInteger count = [self.model.B_TOTAL_JH_MR integerValue];
	if (count == 0) {
		count = 0;
	} else {
		count--;
	}
    self.model.B_TOTAL_JH_MR = [NSString stringWithFormat:@"%ld",(long)count];
	self.countTF.text = self.model.B_TOTAL_JH_MR;
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKAddMRPlanCell";
	MJKAddMRPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
