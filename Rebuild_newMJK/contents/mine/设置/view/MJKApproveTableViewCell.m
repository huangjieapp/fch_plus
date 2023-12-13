//
//  MJKApproveTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/19.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKApproveTableViewCell.h"

@implementation MJKApproveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)switchButtonAction:(UIButton *)sender {
	sender.selected = !sender.isSelected;
	[self.switchButton setBackgroundImage:[UIImage imageNamed:sender.isSelected == YES ? @"8_07.png" : @"9_007"]  forState:UIControlStateNormal];
	
	if (self.backBoolBlock) {
		self.backBoolBlock(sender.isSelected == YES ? @"true" : @"false");
	}
}

- (BOOL)changeBool:(NSString *)str {
	if ([str isEqualToString:@"false"]) {
		return NO;
	} else {
		return YES;
	}
}

- (void)updataCellWithTitle:(NSString *)title andRow:(NSInteger)row andModel:(MJKAppoveModel *)model {
	self.titleLabel.text = title;
	switch (row) {
		case 0: {
			[self.switchButton setBackgroundImage:[UIImage imageNamed:[self changeBool:model.C_ISAUTOFAIL] == YES ? @"8_07.png" : @"9_007"]  forState:UIControlStateNormal];
			self.switchButton.selected = [self changeBool:model.C_ISAUTOFAIL];
		}
			break;
		case 1: {
			[self.switchButton setBackgroundImage:[UIImage imageNamed:[self changeBool:model.C_ISAUTOACT] == YES ? @"8_07.png" : @"9_007"]  forState:UIControlStateNormal];
			self.switchButton.selected = [self changeBool:model.C_ISAUTOACT];
		}
			break;
		case 2:{
			[self.switchButton setBackgroundImage:[UIImage imageNamed:[self changeBool:model.C_ISAUTOPRICE] == YES ? @"8_07.png" : @"9_007"]  forState:UIControlStateNormal];
			self.switchButton.selected = [self changeBool:model.C_ISAUTOPRICE];
		}
			break;
		case 3:{
			[self.switchButton setBackgroundImage:[UIImage imageNamed:[self changeBool:model.C_ISAUTOCANCEL] == YES ? @"8_07.png" : @"9_007"]  forState:UIControlStateNormal];
			self.switchButton.selected = [self changeBool:model.C_ISAUTOCANCEL];
		}
			break;
			
		default:
			break;
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKApproveTableViewCell";
	MJKApproveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
