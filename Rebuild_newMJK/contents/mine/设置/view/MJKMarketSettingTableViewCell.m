//
//  MJKMarketSettingTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKMarketSettingTableViewCell.h"

@implementation MJKMarketSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.statusLabel.textColor = self.editTextField.textColor = DBColor(142, 142, 142);
	self.editTextField.placeholder = @"请选择";
}

//市场

- (void)updateCell:(NSString *)title andStatus:(NSString *)status {
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-100);
    }];
	self.titleLabel.text = title;
	self.statusLabel.text = status;
    self.statusLabel.hidden = YES;
}

- (void)updateDetailCellWithTitle:(NSString *)title andDetailContent:(NSString *)content {
	self.titleLabel.text = title;
	if ([title isEqualToString:@"渠道名称"] || [title isEqualToString:@"渠道代码"] || [title isEqualToString:@"渠道状态"] ) {
		self.titleLabel.textColor = [UIColor redColor];
	}
	self.statusLabel.text = content;
}

- (void)updateEditCellWithTitle:(NSString *)title andDetailContent:(NSString *)content {
	self.titleLabel.text = title;
	if ([title isEqualToString:@"渠道名称"] || [title isEqualToString:@"渠道代码"] || [title isEqualToString:@"来源"] ) {
		self.titleLabel.textColor = [UIColor redColor];
	}
	if ([title isEqualToString:@"渠道名称"] || [title isEqualToString:@"渠道代码"]) {
		self.editTextField.hidden = NO;
		self.statusLabel.hidden = YES;
		self.arrowImageView.hidden = YES;
		self.editTextField.text = content;
		
		
		self.editTextField.borderStyle = UITextBorderStyleNone;
		[self.editTextField addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
	} else {
		self.editTextField.hidden = YES;
		self.statusLabel.hidden = NO;
		self.arrowImageView.hidden = NO;
		self.statusLabel.text = content;
		self.imageLayout.constant = 20 + 20;
		if (self.statusLabel.text.length <= 0) {
			self.statusLabel.text = @"请选择";
		}
	}
	
}

- (void)updateAddCellWithTitle:(NSString *)title andModel:(MJKMarketSetDetailModel *)model andRow:(NSInteger)row {
	self.titleLabel.text = title;
	if ([title isEqualToString:@"渠道名称"] || [title isEqualToString:@"渠道代码"] || [title isEqualToString:@"来源"] ) {
		self.titleLabel.textColor = [UIColor redColor];
	}
	if ([title isEqualToString:@"渠道名称"] || [title isEqualToString:@"渠道代码"]) {
		self.editTextField.hidden = NO;
		self.statusLabel.hidden = YES;
		self.arrowImageView.hidden = YES;
		self.editTextField.placeholder = @"请输入";
		
		self.editTextField.borderStyle = UITextBorderStyleNone;
		[self.editTextField addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
	} else {
		self.editTextField.hidden = YES;
		self.statusLabel.hidden = NO;
		self.arrowImageView.hidden = NO;
		self.imageLayout.constant = 20 + 20;
		self.statusLabel.text = @"请选择";
		
	}
	switch (row) {
		case 0:
			if (model.C_NAME.length) {
				self.editTextField.text = model.C_NAME;
			}
			break;
//        case 1:
//            if (model.C_VOUCHERID.length) {
//                self.editTextField.text = model.C_VOUCHERID;
//            }
//            break;
//        case 2:
//            if (model.C_STATUS_DD_NAME.length) {
//                self.statusLabel.text = model.C_STATUS_DD_NAME;
//            }
//            break;
        case 1:
            if (model.C_CLUESOURCE_DD_NAME.length) {
                self.statusLabel.text = model.C_CLUESOURCE_DD_NAME;
            }
            break;
//        case 3:
//            if (model.D_START_TIME.length) {
//                self.statusLabel.text = model.D_START_TIME;
//            }
//            break;
//        case 4:
//            if (model.D_END_TIME.length) {
//                self.statusLabel.text = model.D_END_TIME;
//            }
//            break;
			
  default:
			break;
	}
	
}

- (void)changeText:(UITextField *)textField {
	if (self.backTextBlock) {
		self.backTextBlock(textField.text);
	}
}

//电话
- (void)updatePhoneCellWith:(NSString *)title andPhone:(NSString *)phone {
	self.phoneLabel.hidden = self.arrowImageView.hidden = NO;;
	self.statusLabel.hidden = YES;
	self.titleLabel.text = title;
	self.phoneLabel.text = phone;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKMarketSettingTableViewCell";
	MJKMarketSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}



@end
