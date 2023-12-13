//
//  MJKAddFlowTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/8.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKAddFlowTableViewCell.h"

@interface MJKAddFlowTableViewCell () <UITextFieldDelegate>
@property (nonatomic, assign) int peopleNumber;
@end

@implementation MJKAddFlowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.peopleNumber = 1;
	self.peopleNumberTextField.textColor = DBColor(142, 142, 142);
	self.peopleNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
	[self.peopleNumberTextField addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKAddFlowTableViewCell";
	MJKAddFlowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		
	}
	return cell;
	
}

- (IBAction)addButtonAction:(UIButton *)sender {
	[self.peopleNumberTextField resignFirstResponder];
	self.peopleNumber++;
	self.peopleNumberTextField.text = [NSString stringWithFormat:@"%d",self.peopleNumber];
	if (self.backTextBlock) {
		self.backTextBlock(self.peopleNumberTextField.text);
	}
}
- (IBAction)subButtonAction:(UIButton *)sender {
	[self.peopleNumberTextField resignFirstResponder];
	self.peopleNumber--;
	if (self.peopleNumber < 1) {
		self.peopleNumber = 1;
	}
	self.peopleNumberTextField.text = [NSString stringWithFormat:@"%d",self.peopleNumber];
	if (self.backTextBlock) {
		self.backTextBlock(self.peopleNumberTextField.text);
	}
}

- (void)changeText:(UITextField *)sender {
	if (self.backTextBlock) {
		self.backTextBlock(sender.text);
	}
	self.peopleNumber = sender.text.intValue;
}

- (void)updateCustomCell:(NSString *)customReturnStr andDays:(NSString *)day andDetail:(BOOL)isDetail {
	self.peopleNumber = day.intValue;
	self.titleLabel.text = customReturnStr;
	self.peopleNumberTextField.text = isDetail ? [NSString stringWithFormat:@"%@天",day] : day;
	self.peopleTextFieldLayout.constant = isDetail ? -10 : 10;
	self.titleLabelLayout.constant = 35;
	self.peopleNumberTextField.enabled = isDetail ? NO : YES;
	self.peopleNumberTextField.borderStyle = isDetail ? UITextBorderStyleNone : UITextBorderStyleRoundedRect;
	self.addButton.hidden = self.subButton.hidden = isDetail ? YES : NO;
}


@end
