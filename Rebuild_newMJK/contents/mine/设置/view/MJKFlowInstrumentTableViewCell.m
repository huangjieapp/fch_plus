//
//  MJKFlowInstrumentTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowInstrumentTableViewCell.h"

@implementation MJKFlowInstrumentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKFlowInstrumentSubModel *)model  {
	_model = model;
	self.titleLabel.text = model.C_NUMBER;
	self.manageLabel.text = model.C_TYPE_DD_NAME;
	self.placeLabel.text = model.X_REMARK.length > 0 ? model.X_REMARK : @"占位字段";
	self.placeLabel.hidden = model.X_REMARK.length > 0 ? NO : YES;
}

- (IBAction)delectButtonAction:(UIButton *)sender {
	if (self.clickDeleteButtonBlock) {
		self.clickDeleteButtonBlock();
	}
}

- (IBAction)editButtonAction:(UIButton *)sender {
	if (self.clickEditButtonBlock) {
		self.clickEditButtonBlock();
	}
}
- (IBAction)liveButtonAction:(UIButton *)sender {
	if (self.clickLiveButtonBlock) {
		self.clickLiveButtonBlock();
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKFlowInstrumentTableViewCell";
	MJKFlowInstrumentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
