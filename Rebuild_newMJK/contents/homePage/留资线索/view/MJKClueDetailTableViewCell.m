//
//  MJKClueDetailTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MJKClueDetailTableViewCell.h"

@interface MJKClueDetailTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, assign) NSInteger row;
@end

@implementation MJKClueDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tagLabel.hidden=YES;
	self.contentTextField.enabled = NO;
	self.contentTextField.textColor = DBColor(131, 131, 131);
}

- (void)updateCellWithDatas:(NSString *)model andTitle:(NSString *)str andRow:(NSInteger)row {
	self.titleLabel.text = str;
    self.contentLabel.text = model;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.hidden = NO;
    self.contentTextField.hidden = YES;
    if (row == 1) {
        if ([self.clueDetailModel.C_STATUS_DD_NAME isEqualToString:@"再下发"] || [self.clueDetailModel.C_STATUS_DD_NAME isEqualToString:@"有意向"]) {
            self.phoneLayoutConstraint.constant = 46;
            self.phoneImageView.image = [UIImage imageNamed:@"跟进详情-客户姓名详细图标.png"];
        }
    } else if (row == 2) {
		NSString *phoneStr;
		if (model.length > 0) {
			if ([[NewUserSession  instance].configData.IS_TELEPHONEPRIVACY isEqualToString:@"0"]) {
				phoneStr = model;
			} else {
				phoneStr = [model stringByReplacingCharactersInRange:NSMakeRange(5, 3) withString:@"***"];
			}
		}
		self.contentLabel.text = phoneStr;
		if (self.clueDetailModel.C_PHONE.length > 0) {
			self.phoneLayoutConstraint.constant = 46;
			self.phoneImageView.image = [UIImage imageNamed:@"订单电话.png"];
        } else {
			self.phoneLayoutConstraint.constant = 16;
			self.phoneImageView.image = [UIImage imageNamed:@""];
		}
    } else if (row == 11) {
        if (self.clueDetailModel.C_A47700_C_NAME.length > 0) {
            self.phoneLayoutConstraint.constant = 46;
            self.phoneImageView.image = [UIImage imageNamed:@"跟进详情-客户姓名详细图标.png"];
        } else {
            self.phoneLayoutConstraint.constant = 16;
            self.phoneImageView.image = [UIImage imageNamed:@""];
        }
    }
    else {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	
}

- (void)updateCell:(NSInteger)row andTitleArray:(NSArray *)arr {
    NSString *str = self.titleArray[row];
	self.row = row;
	if ([str isEqualToString:@"客户姓名"]) {
		NSMutableAttributedString *colorStr = [[NSMutableAttributedString alloc]initWithString:@"客户姓名*"];
		[colorStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 1)];
		self.titleLabel.attributedText = colorStr;
	} else if ([str isEqualToString:@"手机号码"]) {
		NSMutableAttributedString *colorStr = [[NSMutableAttributedString alloc]initWithString:@"手机号码*"];
        [colorStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 1)];
		self.titleLabel.attributedText = colorStr;
		self.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
		[self.contentTextField addTarget:self action:@selector(textEnd:) forControlEvents:UIControlEventEditingDidEnd];
	} else if ([str isEqualToString:@"客户微信"]) {
		NSMutableAttributedString *colorStr = [[NSMutableAttributedString alloc]initWithString:@"客户微信"];
//        [colorStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 1)];
		self.titleLabel.attributedText = colorStr;
	}
	else if ([str isEqualToString:@"来源渠道"]) {
		NSMutableAttributedString *colorStr = [[NSMutableAttributedString alloc]initWithString:@"来源渠道*"];
		[colorStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 1)];
		self.titleLabel.attributedText = colorStr;
	} else {
		self.titleLabel.text = arr[row];
		
	}
	
	
	if ([str isEqualToString:@"来源渠道"] || [str isEqualToString:@"渠道细分"] || [str isEqualToString:@"性别"] || [str isEqualToString:@"介绍人"] || [str isEqualToString:@"业务"]) {
		self.contentTextField.placeholder = @"请选择";
		self.contentTextField.enabled = NO;
		self.arrowImageView.image = [UIImage imageNamed:@"arrow_right2.png"];
		self.phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
		self.phoneLayoutConstraint.constant = 32;
	}
//    else if (row == 10) {
//        
//        self.contentTextField.text = self.dateStr;
//        self.contentTextField.enabled = NO;
//    }
    else {
		self.contentTextField.enabled = YES;
		self.contentTextField.placeholder = @"请输入";
		self.contentTextField.delegate = self;
		[self.contentTextField addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingChanged];
	}
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)endEdit:(UITextField *)textField {
	
	if (self.row == 1) {
		if (self.backNameTextBlock) {
			self.backNameTextBlock(textField.text);
		}
	} else if (self.row == 2) {
		if (self.backPhoneNumberTextBlock) {
			self.backPhoneNumberTextBlock(textField.text);
		}
	} else if ( self.row == 3) {
		if (self.backWeChatNumberBlock) {
			self.backWeChatNumberBlock(textField.text);
		}
	}
	
}

- (void)updateFlowCell:(NSInteger)row {
	self.sepLabel.hidden = YES;
	if (row == 2) {
		self.titleLabel.text = @"到店时间";
		self.contentTextField.text = self.dateStr;
		self.contentTextField.enabled = NO;
	} else {
//        self.titleLabel.text = @"渠道细分";
//        self.contentTextField.placeholder = @"请选择";
//        self.contentTextField.enabled = NO;
//        self.arrowImageView.image = [UIImage imageNamed:@"arrow_right2.png"];
//        self.phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.phoneLayoutConstraint.constant = 32;
	}
}

- (void)updatePhoneFlowCell:(NSInteger)row andDetail:(BOOL)isDetail {
	self.sepLabel.hidden = YES;
	if (row == 0) {
		self.titleLabel.text = @"电话号码";
		self.contentTextField.keyboardType = UIKeyboardTypePhonePad;
		self.contentTextField.placeholder = @"请输入";
		[self.contentTextField addTarget:self action:@selector(endEditPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
		[self.contentTextField addTarget:self action:@selector(textEnd:) forControlEvents:UIControlEventEditingDidEnd];
		self.contentTextField.delegate = self;
		self.contentTextField.enabled = isDetail ? NO : YES;
	} else if (row == 1) {
		self.titleLabel.text = @"来电时间";
		self.contentTextField.enabled = NO;
	} else {
		self.titleLabel.text = @"渠道细分";
        self.tagLabel.hidden=NO;
		self.contentTextField.placeholder = @"请选择";
		self.contentTextField.enabled = NO;
		self.arrowImageView.image = [UIImage imageNamed:@"arrow_right2.png"];
		self.phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
		self.phoneLayoutConstraint.constant = 32;
	}
}

- (void)textEnd:(UITextField *)textField {
	if ([textField.text rangeOfString:@"*"].location !=NSNotFound) {
		[JRToast showWithText:@"请输入正确的电话号码"];
		textField.text = @"";
	}
}

- (void)endEditPhoneNumber:(UITextField *)textField {
	
	if (self.backPhoneNumberTextBlock) {
		self.backPhoneNumberTextBlock(textField.text);
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([string isEqualToString:@""]) {
		return YES;
	}
	if ([string isEqualToString:@" "]) {
		return NO;
	}
	if ([self.vcname isEqualToString:@"线索"]) {
		if (self.row == 2) {
			if (textField.text.length > 10) {
				return NO;
			}
		}
	} else {
		if (self.row == 0) {
			if (textField.text.length > 10) {
				return NO;
			}
		}
	}
	
	
	return YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKClueDetailTableViewCell";
	MJKClueDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		
	}
	return cell;
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
