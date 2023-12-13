//
//  MJKShopArriveTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKShopArriveTableViewCell.h"

@interface MJKShopArriveTableViewCell ()

@end

@implementation MJKShopArriveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//上一个button必须保持住不销毁才有用
static UIButton *arrivePreButton;
- (IBAction)selectButtonAction:(UIButton *)sender {
	sender.selected = !sender.isSelected;
	if (arrivePreButton) {
		[arrivePreButton setImage:[UIImage imageNamed:@"icon_1_normal.png"] forState:UIControlStateNormal];
	}
	[sender setImage:[UIImage imageNamed:@"icon_1_highlight.png"] forState:UIControlStateNormal];
	arrivePreButton = sender;
	if (self.backModel) {
		self.backModel(self.model);
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKShopArriveTableViewCell";
	MJKShopArriveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
}

@end
