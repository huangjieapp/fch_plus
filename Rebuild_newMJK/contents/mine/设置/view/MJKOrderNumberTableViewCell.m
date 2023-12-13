//
//  MJKOrderNumberTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKOrderNumberTableViewCell.h"
#import "NSString+Extern.h"

@interface MJKOrderNumberTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, assign) NSInteger row;
@end

@implementation MJKOrderNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTextField.delegate = self;
	[self.contentTextField addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
}

- (void)updataCellTitle:(NSArray *)titleArr andContent:(NSArray *)contentArr andRow:(NSInteger)row {
	self.titleLabel.text = titleArr[row];
	self.contentTextField.text = contentArr[row];
	self.row = row;
	if (row == 1) {
		self.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKOrderNumberTableViewCell";
	MJKOrderNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

- (void)changeText:(UITextField *)tf {
	if (self.backTextBlock) {
		self.backTextBlock(tf.text);
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (self.row == 0) {
		if ([string isEqualToString:@""]) {
			return YES;
		}
		if (![string isValid]) {
			return NO;
		}
	}
	
	
	return YES;
}

@end
