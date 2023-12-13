//
//  MJKSetWorkTaskCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/29.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKSetWorkTaskCell.h"

#import "MJKClueListSubModel.h"

@interface MJKSetWorkTaskCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@end

@implementation MJKSetWorkTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(MJKClueListSubModel *)model {
	_model = model;
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
	self.nameLabel.text = model.nickName;
	if ([model.schedulingCheckFlag boolValue] == NO) {
		self.selectedButton.selected = NO;
		model.selected = NO;
	} else {
		self.selectedButton.selected = YES;
		model.selected = YES;
	}
}

- (IBAction)selectedButtonAction:(UIButton *)sender {
	sender.selected = !sender.isSelected;
	self.model.selected = !self.model.isSelected;
	if (self.backSelectBlock) {
		self.backSelectBlock();
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKSetWorkTaskCell";
	MJKSetWorkTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}
@end
