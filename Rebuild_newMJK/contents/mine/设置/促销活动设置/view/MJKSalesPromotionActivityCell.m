//
//  MJKSalesPromotionActivityCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/10.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKSalesPromotionActivityCell.h"

@interface MJKSalesPromotionActivityCell ()
@property (weak, nonatomic) IBOutlet UILabel *activityNamelLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation MJKSalesPromotionActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKMarketSubModel *)model {
	_model = model;
	self.activityNamelLabel.text = model.C_NAME;
	self.statusLabel.text = model.C_STATUS_DD_NAME;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKSalesPromotionActivityCell";
	MJKSalesPromotionActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
