//
//  MJKAddFlowShopTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/8.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKAddFlowShopTableViewCell.h"

@interface MJKAddFlowShopTableViewCell ()

@end

@implementation MJKAddFlowShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.orderLabel.text = @"预约到店";
}

- (IBAction)randomButtonAction:(UIButton *)sender {
	sender.selected = YES;
	if (self.orderButton.isSelected == YES || self.invalidButton.isSelected == YES) {
		self.orderButton.selected = NO;
		[self.orderButton setBackgroundImage:[UIImage imageNamed:@"icon_1_normal.png"] forState:UIControlStateNormal];
		self.invalidButton.selected = NO;
		[self.invalidButton setBackgroundImage:[UIImage imageNamed:@"icon_1_normal.png"] forState:UIControlStateNormal];
	}
	[sender setBackgroundImage:[UIImage imageNamed:@"icon_1_highlight.png"] forState:UIControlStateNormal];
	if (self.backFlowShopBlock) {
		self.backFlowShopBlock(@"C_CLUESOURCE_DD_0000");
	}
}

- (IBAction)orderButtonAction:(UIButton *)sender {
	sender.selected = YES;
	if (self.randomButton.isSelected == YES || self.invalidButton.isSelected == YES) {
		self.randomButton.selected = NO;
		[self.randomButton setBackgroundImage:[UIImage imageNamed:@"icon_1_normal.png"] forState:UIControlStateNormal];
		self.invalidButton.selected = NO;
		[self.invalidButton setBackgroundImage:[UIImage imageNamed:@"icon_1_normal.png"] forState:UIControlStateNormal];
	}
	[sender setBackgroundImage:[UIImage imageNamed:@"icon_1_highlight.png"] forState:UIControlStateNormal];
	if (self.backFlowShopBlock) {
		self.backFlowShopBlock(@"C_CLUESOURCE_DD_0002");
	}
}
- (IBAction)invalidButtonAction:(UIButton *)sender {
	sender.selected = YES;
	if (self.randomButton.isSelected == YES || self.orderButton.isSelected == YES) {
		self.randomButton.selected = NO;
		[self.randomButton setBackgroundImage:[UIImage imageNamed:@"icon_1_normal.png"] forState:UIControlStateNormal];
		self.orderButton.selected = NO;
		[self.orderButton setBackgroundImage:[UIImage imageNamed:@"icon_1_normal.png"] forState:UIControlStateNormal];
	}
	[sender setBackgroundImage:[UIImage imageNamed:@"icon_1_highlight.png"] forState:UIControlStateNormal];
	if (self.backFlowShopBlock) {
		self.backFlowShopBlock(@"C_CLUESOURCE_DD_0003");
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKAddFlowShopTableViewCell";
	MJKAddFlowShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
}

@end
