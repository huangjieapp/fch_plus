//
//  MJKOrderNodeCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/12.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKOrderNodeCell.h"

#import "MJKOrderMoneyListModel.h"

@implementation MJKOrderNodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKOrderMoneyListModel *)model {
	_model = model;
	self.titleLabel.text = model.C_NAME;
	self.contentLabel.text = model.C_TYPE_DD_NAME;
	self.signButton.hidden = [model.I_RWTYPE isEqualToString:@"1"] ? NO : YES;
    self.signLeftLayout.constant = [model.I_RWTYPE isEqualToString:@"0"] ? -20 : 2;
}

- (IBAction)exchangeObjectAction:(UIButton *)sender {
	//tag 100 为上 101 为下
	if (self.exchangeObjectBlock) {
			self.exchangeObjectBlock(sender.tag == 100 ? @"up" : @"down");
	}
}
- (IBAction)addObjectAction:(id)sender {
	if (self.addObjectBlock) {
		self.addObjectBlock();
	}
}
- (IBAction)editObjectAction:(UIButton *)sender {
	//tag 1000 为编辑 1001 为删除
	if (self.editObjectBlock) {
		self.editObjectBlock(sender.tag == 1000 ? @"edit" : @"delete");
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKOrderNodeCell";
	MJKOrderNodeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
