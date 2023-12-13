//
//  MJKWorkReportSetCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/9.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKWorkReportSetCell.h"

#import "MJKPushDefaultListModel.h"

@implementation MJKWorkReportSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)selectButtonAction:(UIButton *)sender {
    if (self.selectButtonBlock) {
        self.selectButtonBlock();
    }
}

- (void)setModel:(MJKDataDicModel *)model {
	_model = model;
	self.selectImageView.hidden = NO;
	self.labelLeftLayout.constant = 40;
	self.nameLabel.text = model.C_NAME;
	if (model.isSelected == YES) {
		[self.selectImageView setImage:[UIImage imageNamed:@"kuangselected"]];
	} else {
		[self.selectImageView setImage:[UIImage imageNamed:@"kuang_off"]];
	}
}

- (void)setSeaModel:(MJKCustomReturnSubModel *)seaModel {
	_seaModel = seaModel;
	if ([seaModel.C_NAME isEqualToString:@"领用量"]) {
		self.nameLabel.text = [NSString stringWithFormat:@"每人每天公海客户%@不超过%@个",seaModel.C_NAME,seaModel.I_NUMBER];
	} else if ([seaModel.C_NAME isEqualToString:@"自己归还的客户，不能领用"]) {
        self.nameLabel.text = seaModel.C_NAME;
    } else {
		self.nameLabel.text = [NSString stringWithFormat:@"%@%@天,客户自动转入公海",seaModel.C_NAME,seaModel.I_NUMBER];
	}
	if ([seaModel.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
		seaModel.selected = YES;
		self.openSwitchButton.on = YES;
	} else {
		seaModel.selected = NO;
		self.openSwitchButton.on = NO;
	}
}
- (IBAction)openSwitchButtonAction:(UISwitch *)sender {
	if (self.openSwitchBlock) {
		self.openSwitchBlock(sender.isOn);
	}
}

- (void)setSafeModel:(MJKCustomReturnSubModel *)safeModel {
	_safeModel = safeModel;
	if ([safeModel.C_NAME isEqualToString:@"未登录系统"]) {
		if ([safeModel.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
			self.nameLabel.text = [NSString stringWithFormat:@"%@天%@，强制短信验证",safeModel.I_NUMBER,safeModel.C_NAME];
		} else {
			self.nameLabel.text = [NSString stringWithFormat:@"%@天%@，强制短信验证",safeModel.I_NUMBER,safeModel.C_NAME];
		}
	} else if ([safeModel.C_NAME isEqualToString:@"更换设备登录"]) {
		if ([safeModel.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
			self.nameLabel.text = [NSString stringWithFormat:@"%@，强制短信验证",safeModel.C_NAME];
		} else {
			self.nameLabel.text = [NSString stringWithFormat:@"%@，强制短信验证",safeModel.C_NAME];
		}
	} else {
		if ([safeModel.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
			self.nameLabel.text = [NSString stringWithFormat:@"%@隐私保护",safeModel.C_NAME];
		} else {
			self.nameLabel.text = [NSString stringWithFormat:@"%@隐私保护",safeModel.C_NAME];
		}
	}
	
	if ([safeModel.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
		safeModel.selected = YES;
		self.openSwitchButton.on = YES;
	} else {
		safeModel.selected = NO;
		self.openSwitchButton.on = NO;
	}
//	if ([safeModel.C_STATUS_DD_NAME isEqualToString:@"开启"]) {
//		safeModel.selected = YES;
//	} else {
//		safeModel.selected = NO;
//	}
//	if (safeModel.isSelected == YES) {
//		[self.selectImageView setImage:[UIImage imageNamed:@"kuangselected"]];
//	} else {
//		[self.selectImageView setImage:[UIImage imageNamed:@"kuang_off"]];
//	}
	
}

- (void)setDefaultModel:(MJKPushDefaultListModel *)defaultModel {
    _defaultModel = defaultModel;
    self.labelLeftLayout.constant = 45;
    self.headImage.hidden = NO;
    self.nameLabel.text = defaultModel.NAME;
    self.headImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@图标应用",defaultModel.NAME]];
    if ([defaultModel.ISCHECK isEqualToString:@"true"]) {
        self.openSwitchButton.on = YES;
    } else {
        self.openSwitchButton.on = NO;
    }
}

- (void)setRemindModel:(MJKCustomReturnSubModel *)remindModel {
    _remindModel = remindModel;
    self.nameLabel.text = remindModel.C_NAME;
    if ([remindModel.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
        remindModel.selected = YES;
        self.openSwitchButton.on = YES;
    } else {
        remindModel.selected = NO;
        self.openSwitchButton.on = NO;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKWorkReportSetCell";
	MJKWorkReportSetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
