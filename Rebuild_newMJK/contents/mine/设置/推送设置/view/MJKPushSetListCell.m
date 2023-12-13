//
//  MJKPushSetListCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/16.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKPushSetListCell.h"
#import "MJKCustomReturnSubModel.h"
#import "MJKPushDefaultListModel.h"

@interface MJKPushSetListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeftLayout;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelRightLayout;
@property (weak, nonatomic) IBOutlet UILabel *messageOpenLabel;

@end

@implementation MJKPushSetListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)openSwitchButtonAction:(UISwitch *)sender {
    if (self.openSwitchBlock) {
        self.openSwitchBlock(sender.isOn);
    }
}

- (void)setModel:(MJKCustomReturnSubModel *)model {
	_model = model;
	self.titleLabel.text = model.C_NAME;
    self.selectImageView.hidden = YES;
	self.selectImageView.image = [UIImage imageNamed:[model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] ? @"kuangselected" : @"kuang_off"];
	self.model.selected = [model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] ? YES : NO;
    self.openSwitchButton.on = [model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] ? YES : NO;
    if ([model.C_VOUCHERID isEqualToString:@"A47500_C_JXTS_0000"] || [model.C_VOUCHERID isEqualToString:@"A47500_C_JXTS_0001"]) {
        self.messageOpenLabel.hidden = [model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] ? NO : YES;
        self.messageOpenLabel.text = @"公众号推送";
    }
}

- (void)setRpModel:(MJKCustomReturnSubModel *)rpModel {
    _rpModel = rpModel;
    self.titleLabel.text = rpModel.C_NAME;
    self.selectImageView.hidden = YES;
    self.rpModel.selected = [rpModel.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] ? YES : NO;
    self.openSwitchButton.on = [rpModel.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] ? YES : NO;
    if (self.selectedSegmentIndex == 0) {
        self.messageOpenLabel.text = rpModel.C_XFTYPE_DD_NAME;
        self.messageOpenLabel.hidden = [rpModel.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] ? NO : YES;
    } else {
        self.messageOpenLabel.hidden = YES;
    }
}

- (IBAction)openButtonAction:(UIButton *)sender {
	self.model.selected = !self.model.isSelected;
	if (self.model.isSelected == YES) {
		[sender setTitleNormal:@"关闭"];
//		self.model.C_STATUS_DD_ID = @"A47500_C_STATUS_0000";
		
		[sender setBackgroundColor:KNaviColor];
	} else {
		[sender setTitleNormal:@"开启"];
//		self.model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
		[sender setBackgroundColor:kBackgroundColor];
	}
	if (self.openButtonBlock) {
		self.openButtonBlock(self.model.isSelected);
	}
}

- (IBAction)editButtonAction:(UIButton *)sender {
	if (self.editButtonBlock) {
		self.editButtonBlock();
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKPushSetListCell";
	MJKPushSetListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
