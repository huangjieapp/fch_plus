//
//  MJKSeaSettingCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKSeaSettingCell.h"

@implementation MJKSeaSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)openButtonAction:(UIButton *)sender {
	DBSelf(weakSelf);
	if (self.safeModel != nil) {
		if ([self.safeModel.C_STATUS_DD_NAME isEqualToString:@"开启"]) {
			//状态为开启，则文字为关闭，点击关闭文字变成开启,但状态为关闭
			[sender setTitleNormal:@"开启"];
			if ([self.safeModel.C_NAME isEqualToString:@"电话号码"]) {
				[NewUserSession instance].configData.IS_TELEPHONEPRIVACY = @"0";
			}
			self.openButton.backgroundColor = kBackgroundColor;
//			self.inputTextField.borderStyle = UITextBorderStyleNone;
//			self.inputTextField.enabled = NO;
			self.safeModel.C_STATUS_DD_NAME = @"关闭";
			self.safeModel.C_STATUS_DD_ID =  @"A47500_C_STATUS_0001";// 关闭状态id
			if (self.backButtonActionBlock) {
				self.backButtonActionBlock(self.safeModel);
			}
		} else {
//			self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
//			self.inputTextField.enabled = YES;
			if ([self.safeModel.C_NAME isEqualToString:@"未登录系统"]) {
				UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入未登录系统启用短信验证天数" preferredStyle:UIAlertControllerStyleAlert];
				[alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
					textField.text = weakSelf.safeModel.I_NUMBER;
				}];
				
				//添加一个取消按钮
				[alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
				
				//添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
				[alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					[sender setTitleNormal:@"关闭"];
					self.openButton.backgroundColor = KNaviColor;
					weakSelf.safeModel.C_STATUS_DD_NAME = @"开启";
					weakSelf.safeModel.C_STATUS_DD_ID =  @"A47500_C_STATUS_0000";//开启状态id
					UITextField *envirnmentNameTextField = alertC.textFields.firstObject;
					weakSelf.safeModel.I_NUMBER = envirnmentNameTextField.text;
					if (weakSelf.backButtonActionBlock) {
						weakSelf.backButtonActionBlock(self.safeModel);
					}
					
				}]];
				//present出AlertView
				[self.rootVC presentViewController:alertC animated:true completion:nil];
			} else {
				[sender setTitleNormal:@"关闭"];
				if ([self.safeModel.C_NAME isEqualToString:@"电话号码"]) {
                    [NewUserSession instance].configData.IS_TELEPHONEPRIVACY = @"1";
				}
				self.openButton.backgroundColor = KNaviColor;
				self.safeModel.C_STATUS_DD_NAME = @"开启";
				self.safeModel.C_STATUS_DD_ID =  @"A47500_C_STATUS_0000";//开启状态id
				if (self.backButtonActionBlock) {
					self.backButtonActionBlock(self.safeModel);
				}
			}
		}
		
	}
	if (self.seaModel != nil) {
		if ([self.seaModel.C_STATUS_DD_NAME isEqualToString:@"开启"]) {
			//状态为开启，则文字为关闭，点击关闭文字变成开启,但状态为关闭
			[sender setTitleNormal:@"开启"];
			self.openButton.backgroundColor = kBackgroundColor;
			self.inputTextField.borderStyle = UITextBorderStyleNone;
			self.inputTextField.enabled = NO;
			self.seaModel.C_STATUS_DD_NAME = @"关闭";
			self.seaModel.C_STATUS_DD_ID =  @"A47500_C_STATUS_0001";// 关闭状态id
			
		} else {
			[sender setTitleNormal:@"关闭"];
			self.openButton.backgroundColor = KNaviColor;
			self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
			self.inputTextField.enabled = YES;
			self.seaModel.C_STATUS_DD_NAME = @"开启";
			self.seaModel.C_STATUS_DD_ID =  @"A47500_C_STATUS_0000";//开启状态id
		}
		if (self.backButtonActionBlock) {
			self.backButtonActionBlock(self.seaModel);
		}
	}
	
	if (self.model != nil) {
		if (self.model.isSelected == YES) {
			[sender setTitleNormal:@"开启"];
			self.openButton.backgroundColor = kBackgroundColor;
			self.model.selected = NO;
		} else {
			[sender setTitleNormal:@"关闭"];
			self.openButton.backgroundColor = KNaviColor;
			self.model.selected = YES;
		}
	}
	
}
//汇报
- (void)setModel:(MJKDataDicModel *)model {
	_model = model;
	self.inputTextField.hidden = YES;
	self.titleLabel.text = model.C_NAME;
	self.unitLabel.hidden = YES;
	if (model.isSelected == YES) {
		[self.openButton setTitleNormal:@"关闭"];
		self.openButton.backgroundColor = KNaviColor;
	} else {
		[self.openButton setTitleNormal:@"开启"];
		self.openButton.backgroundColor = kBackgroundColor;
	}
}
//公海
- (void)setSeaModel:(MJKCustomReturnSubModel *)seaModel {
	_seaModel = seaModel;
	self.titleLabel.text = seaModel.C_NAME;
	self.inputTextField.text = seaModel.I_NUMBER;
	if ([seaModel.C_NAME isEqualToString:@"领用量"]) {
		self.unitLabel.text = @"个/天";
	} else {
		self.unitLabel.text = @"天";
	}
	if ([seaModel.C_STATUS_DD_NAME isEqualToString:@"开启"]) {
		[self.openButton setTitleNormal:@"关闭"];
		self.openButton.backgroundColor = KNaviColor;
		self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
		self.inputTextField.enabled = YES;
	} else {
		[self.openButton setTitleNormal:@"开启"];
		self.openButton.backgroundColor = kBackgroundColor;
		self.inputTextField.borderStyle = UITextBorderStyleNone;
		self.inputTextField.enabled = NO;
	}
}

//安全设置
- (void)setSafeModel:(MJKCustomReturnSubModel *)safeModel {
	_safeModel = safeModel;
	if ([safeModel.C_NAME isEqualToString:@"未登录系统"]) {
//		self.inputTextField.text = safeModel.I_NUMBER;
//		self.unitLabel.text = @"天";
		self.titleLabel.text = [NSString stringWithFormat:@"%@天%@,启用短信验证",safeModel.I_NUMBER,safeModel.C_NAME];
	} else if ([safeModel.C_NAME isEqualToString:@"更换设备登录系统"]) {
		self.titleLabel.text = [safeModel.C_NAME stringByAppendingString:@",启用短信验证"];
	} else {
		self.titleLabel.text = [safeModel.C_NAME stringByAppendingString:@",启用隐私保护功能"];
	}
	self.inputTextField.hidden = YES;
	self.unitLabel.hidden = YES;
	
	if ([safeModel.C_STATUS_DD_NAME isEqualToString:@"开启"]) {
		[self.openButton setTitleNormal:@"关闭"];
		self.openButton.backgroundColor = KNaviColor;
//		self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
//		self.inputTextField.enabled = YES;
	} else {
		[self.openButton setTitleNormal:@"开启"];
		self.openButton.backgroundColor = kBackgroundColor;
//		self.inputTextField.borderStyle = UITextBorderStyleNone;
//		self.inputTextField.enabled = NO;
	}
}

- (IBAction)inputTextEidtEnd:(UITextField *)sender {
	if (self.safeModel != nil) {
		self.safeModel.I_NUMBER = sender.text;
		if (self.textChangeBlock) {
			self.textChangeBlock(self.safeModel);
		}
	} else if (self.seaModel != nil) {
		self.seaModel.I_NUMBER = sender.text;
		if (self.textChangeBlock) {
			self.textChangeBlock(self.seaModel);
		}
	}
	
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKSeaSettingCell";
	MJKSeaSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
