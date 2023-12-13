//
//  MJKFlowMeterDetailTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/10.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowMeterDetailTableViewCell.h"

@implementation MJKFlowMeterDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)toCustomerAction:(UIButton *)sender {
	if (self.toCustomerBlock) {
		self.toCustomerBlock();
	}
}

- (void)updataCellWithTitleArray:(NSArray *)titleArr andContent:(NSArray *)contentArr andIndexPath:(NSIndexPath *)indexPath {
	
	self.titleLabel.text = titleArr[indexPath.section][indexPath.row];
	self.contentLabel.text = contentArr[indexPath.section][indexPath.row];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKFlowMeterDetailTableViewCell";
	MJKFlowMeterDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
