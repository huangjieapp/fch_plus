//
//  MJKAddFlowSubTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/8.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKAddFlowSubTableViewCell.h"

@interface MJKAddFlowSubTableViewCell ()
@property (nonatomic, strong) MJKClueListSubModel *saleModel;
@end

@implementation MJKAddFlowSubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)invalidButtonAction:(UIButton *)sender {
	if (self.saleModel != nil) /*self.saleModel 不为空是则是电话设置修改是使用该cell*/{
		self.saleModel.selected = !self.saleModel.isSelected;
		[self.invalidButton setBackgroundImage:[UIImage imageNamed:self.saleModel.isSelected == YES ? @"kuangselected.png" : @"kuang_off.png"] forState:UIControlStateNormal];
//		if (self.saleModel.isSelected == YES) {
//			if (self.backFlowShopBlock) {
//				self.backFlowShopBlock(self.saleModel.C_ID);
//			}
//		}
		
	} else {
		sender.selected = YES;
		if (self.backFlowShopBlock) {
			self.backFlowShopBlock(self.invalidLabel.text);
		}
	}
	
}

- (void)updatePhoneCell:(NSString *)str {
	self.invalidLabel.text = str;
	[self.invalidButton setBackgroundImage:[UIImage imageNamed:@"kuangselected.png"] forState:UIControlStateNormal];
}

- (void)updateEditPhoneCell:(MJKClueListSubModel *)model {
	self.saleModel = model;
	self.invalidLabel.text = model.nickName;
	[self.invalidButton setBackgroundImage:[UIImage imageNamed:model.isSelected == YES ? @"kuangselected.png" : @"kuang_off.png"] forState:UIControlStateNormal];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKAddFlowSubTableViewCell";
	MJKAddFlowSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
}

@end
