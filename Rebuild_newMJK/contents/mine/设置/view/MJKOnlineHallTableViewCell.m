//
//  MJKOnlineHallTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKOnlineHallTableViewCell.h"

@implementation MJKOnlineHallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKFlowInstrumentSubModel *)model {
	self.typeLabel.text = model.C_TYPE_DD_NAME;
	self.placeLabel.text = model.C_POSITION;
}

- (void)updataDetailTitle:(NSString *)title andModel:(MJKFlowInstrumentSubModel *)model andRow:(NSInteger)row  {
	self.placeLabel.hidden = self.editButton.hidden = YES;
	self.contentLabel.hidden = NO;
	self.typeLabel.text = title;
	if (row == 0) {
		self.contentLabel.text = model.C_POSITION;
	} else if (row == 1) {
		self.contentLabel.text = model.C_NUMBER;
	} else if (row == 2) {
		self.contentLabel.text = model.C_CHANNEL_NUMBER;
    } /*else if (row == 3) {
        self.contentLabel.text = model.C_A68000_C_NAME;
	}*/ else if (row == 3) {
		self.contentLabel.text = model.X_REMARK;
	}
	
}

- (void)updataChangeCellTitle:(NSString *)title andModel:(MJKFlowInstrumentSubModel *)model andRow:(NSInteger)row  {
	self.placeLabel.hidden = self.editButton.hidden = YES;
	self.contentLabel.hidden = YES;
	self.contentTextField.hidden = NO;
	self.contentTextField.textAlignment = NSTextAlignmentRight;
	self.typeLabel.text = title;
	self.contentTextField.placeholder = @"请输入";
	if (row == 0) {
		self.contentTextField.text = model.C_POSITION;
	} else if (row == 1) {
		self.contentTextField.text = model.C_NUMBER;
	} else if (row == 2) {
		self.contentTextField.text = model.C_CHANNEL_NUMBER;
    } /*else if (row == 3) {
        self.contentLabel.hidden = NO;
        self.editButton.hidden = NO;
        self.contentTextField.hidden = YES;
        [self.editButton setBackgroundImage:[UIImage imageNamed:@"arrow_right2.png"] forState:UIControlStateNormal];
        self.contentLabel.text = model.C_A68000_C_NAME;
	}*/ else if (row == 3) {
		self.contentTextField.text = model.X_REMARK;
	}
	[self.contentTextField addTarget:self action:@selector(changeValues:) forControlEvents:UIControlEventEditingChanged];
}

- (void)changeValues:(UITextField *)textField {
	if (self.backChangeTextBlock) {
		self.backChangeTextBlock(textField.text);
	}
}

- (IBAction)editButtonAction:(UIButton *)sender {
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKOnlineHallTableViewCell";
	MJKOnlineHallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
