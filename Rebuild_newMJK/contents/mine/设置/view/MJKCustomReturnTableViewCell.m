//
//  MJKCustomReturnTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKCustomReturnTableViewCell.h"

#import "MJOwnerResultsModel.h"
#import "MJKPersonalPerformanceTargetModel.h"

@interface MJKCustomReturnTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, assign) NSInteger row;
@end

@implementation MJKCustomReturnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.numberTextField addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
}

- (void)updataCell:(NSString *)customName {
	self.numberTextField.hidden = YES;
	self.titleLabel.text = customName;
	[self.selectButton setBackgroundImage:[UIImage imageNamed:[self.model.FLAG isEqualToString:@"true"] ? @"icon_1_highlight" : @"icon_1_normal"] forState:UIControlStateNormal];
}

- (void)updataNumberCell:(MJKPersonalPerformanceTargetModel *)model {
    self.selectButton.hidden = YES;
    self.titleLabel.text = model.C_TYPE_DD_NAME;
    self.numLabel.textColor = DBColor(142, 142, 142);
    
    
    self.numLabel.hidden = NO;
    self.numberTextField.hidden = YES;
    self.openSwitchButton.hidden = NO;
    self.openSwitchButton.on = [model.C_SATUS_DD_ID isEqualToString:@"A70900_C_STATUS_0000"] ? YES : NO;
}

- (void)updataNumberCell:(MJKCustomReturnModel *)model andTitleArray:(NSArray *)titleArray andDetail:(BOOL)isDetail andRow:(NSInteger)row andStatusArray:(NSArray *)statusArray {
	self.row = row;
	self.selectButton.hidden = YES;
	self.titleLabel.text = titleArray[row];
	self.numLabel.textColor = DBColor(142, 142, 142);
    
    MJOwnerResultsModel *statusModel = statusArray[row];
    
//	self.numberTextField.textColor = DBColor(142, 142, 142);
//	self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    //@[@"名单新增"1, @"客户新增"2,@"邀约到店"3,@"客户跟进"4, @"订单新增"5,@"预估金额"6,@"回款金额"7,@"订单完工"8]
	//@[@"回款金额"6 0, @"预估金额"5 1,@"订单新增"4 2,@"订单完工"7 3, @"客户新增"1 4,@"客户跟进3" 5,@"主动营销"0 6,@"预约到店"2 7]
//	switch (row) {
//		case 0:
//			self.numberTextField.text = model.B_SJHKMB;
//			self.numberTextField.tag = 403;
//			break;
//		case 1:
//			self.numberTextField.text = model.B_YGJEMB;
//			self.numberTextField.tag = 402;
//			break;
//		case 2:
//			self.numberTextField.text = model.I_A42000INSERT_NUMBER;
//			self.numberTextField.tag = 400;
//			break;
//		case 3:
//			self.numberTextField.text = model.I_A42000_NUMBER;
//			self.numberTextField.tag = 401;
//			break;
//		case 4:
//			self.numberTextField.text = model.I_A41500_NUMBER;
//			self.numberTextField.tag = 404;
//			break;
//		case 5:
//			self.numberTextField.text = model.I_A41600_NUMBER;
//			self.numberTextField.tag = 405;
//			break;
//		case 6:
//			self.numberTextField.text = model.I_A41300_CLUENUMBER;
//			self.numberTextField.tag = 406;
//			break;
//		case 7:
//			self.numberTextField.text = model.I_A41600_YUYUENUMBER;
//			self.numberTextField.tag = 407;
//			break;
//		default:
//			break;
//	}
	switch (row) {
		case 0:
			self.numLabel.text = model.B_SJHKMB;
			self.numberTextField.tag = 403;
			break;
		case 1:
			self.numLabel.text = model.B_YGJEMB;
			self.numberTextField.tag = 402;
			break;
		case 2:
			self.numLabel.text = model.I_A42000INSERT_NUMBER;
			self.numberTextField.tag = 400;
			break;
		case 3:
			self.numLabel.text = model.I_A42000_NUMBER;
			self.numberTextField.tag = 401;
			break;
		case 4:
			self.numLabel.text = model.I_A41500_NUMBER;
			self.numberTextField.tag = 404;
			break;
		case 5:
			self.numLabel.text = model.I_A41600_NUMBER;
			self.numberTextField.tag = 405;
			break;
		case 6:
			self.numLabel.text = model.I_A41300_CLUENUMBER;
			self.numberTextField.tag = 406;
			break;
		case 7:
			self.numLabel.text = model.I_A41600_YUYUENUMBER;
			self.numberTextField.tag = 407;
			break;
		default:
			break;
	}
	self.numLabel.hidden = isDetail ? NO : YES;
	self.numberTextField.hidden = YES;
	self.openSwitchButton.hidden = NO;
    self.openSwitchButton.on = [statusModel.STATUS isEqualToString:@"0"] ? NO : YES;
//	self.numberTextField.enabled = isDetail ? NO : YES;
//	self.numberTextField.borderStyle = isDetail ? UITextBorderStyleNone : UITextBorderStyleRoundedRect;
//    [self.numberTextField addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
//	self.numberTextField.delegate = self;
}
- (IBAction)openSwitchButtonAction:(UISwitch *)sender {
	if (self.openSwitchBlock) {
		self.openSwitchBlock(sender.isOn);
	}
}

- (IBAction)selectButtonAction:(UIButton *)sender {
	NSString *selectStr = @"";
	if ([self.model.FLAG isEqualToString:@"true"]) {
		self.model.FLAG = @"false";
		selectStr = @"0";
	} else {
		self.model.FLAG = @"true";
		selectStr = @"1";
	}
	self.model.selected = !self.model.isSelected;
	[sender setBackgroundImage:[UIImage imageNamed:[self.model.FLAG isEqualToString:@"true"] ? @"icon_1_highlight" : @"icon_1_normal"] forState:UIControlStateNormal];
	if (self.backSelectBlock) {
		self.backSelectBlock(self.model.C_ID, selectStr);
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if ([textField.text isEqualToString:@"0"]) {
		textField.text = @"";
	}
    if (self.textFieldEdit) {
        self.textFieldEdit(textField);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.textFieldEndEdit) {
        self.textFieldEndEdit(textField);
    }
}

- (void)changeText:(UITextField *)textField {
	if (self.backTextBlock) {
		self.backTextBlock(textField.text.length > 0 ? textField.text : @"0", self.row);
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKCustomReturnTableViewCell";
	MJKCustomReturnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
