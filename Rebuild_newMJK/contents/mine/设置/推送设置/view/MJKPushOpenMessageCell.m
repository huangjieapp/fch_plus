//
//  MJKPushOpenSetSection0Cell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKPushOpenMessageCell.h"
#import "MJKCustomReturnSubModel.h"

@interface MJKPushOpenMessageCell ()
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitchButton;

@end

@implementation MJKPushOpenMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
}
- (IBAction)openSwitchAction:(UISwitch *)sender {
    if ([self.titleLabel.text isEqualToString:@"短信通知"]) {
        self.model.I_TYPE = self.model.I_TYPE == 1 ? 0 : 1;
    } else if ([self.titleLabel.text isEqualToString:@"公众号通知"]) {
        self.model.I_WECHAT = self.model.I_WECHAT == 1 ? 0 : 1;
    } else {
        self.model.I_JGTS = self.model.I_JGTS == 1 ? 0 : 1;
    }
    if (self.openSwitchBlock) {
        self.openSwitchBlock(sender.isOn);
    }
}

- (void)setModel:(MJKCustomReturnSubModel *)model {
	_model = model;
    if ([self.titleLabel.text isEqualToString:@"短信通知"]) {
        self.openSwitchButton.on = model.I_TYPE == 0 ? NO : YES;
    } else if ([self.titleLabel.text isEqualToString:@"公众号通知"]) {
        self.openSwitchButton.on = model.I_WECHAT == 0 ? NO : YES;
    } else {
        self.openSwitchButton.on = model.I_JGTS == 0 ? NO : YES;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKPushOpenMessageCell";
	MJKPushOpenMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
