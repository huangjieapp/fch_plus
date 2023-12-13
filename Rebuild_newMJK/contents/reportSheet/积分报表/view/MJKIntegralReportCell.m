//
//  MJKIntegralReportCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/24.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKIntegralReportCell.h"
#import "MJKSourceShowModel.h"

@interface MJKIntegralReportCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;
@property (weak, nonatomic) IBOutlet UIButton *todayButton;

@end

@implementation MJKIntegralReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKSourceShowModel *)model {
	_model = model;
	self.nameLabel.text = model.C_NAME;
	self.monthLabel.text = model.I_INTERGRAL_MONTH;
	self.todayLabel.text = model.I_INTERGRAL_DAY;
}
- (IBAction)monthButtonAction:(UIButton *)sender {
	if (self.detailButtonBlock) {
		self.detailButtonBlock(@"month");
	}
}
- (IBAction)todayButtonAction:(UIButton *)sender {
	if (self.detailButtonBlock) {
		self.detailButtonBlock(@"today");
	}
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKIntegralReportCell";
	MJKIntegralReportCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}
@end
