//
//  MJKStatementsMonthCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/8.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKStatementsMonthCell.h"

@implementation MJKStatementsMonthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)updateCellWithModel:(MJKMonthStatementsModel *)model {
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"logo-头像"]];
	self.nameLabel.text = model.C_NAME;
	for (MJKMonthStatementsContentModel *subModel in model.statusContent) {
		if ([subModel.C_STATUS_DD_NAME isEqualToString:@"已交"]) {
			self.deliveryLabel.text = subModel.COUNT;
		} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"未交"]) {
			self.noDeliveryLabel.text = subModel.COUNT;
		} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"休假"]) {
			self.vacationLabel.text = subModel.COUNT;
		}
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKStatementsMonthCell";
	MJKStatementsMonthCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
