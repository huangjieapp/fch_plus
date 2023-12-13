//
//  MJKPushOpenSetSection0Cell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKPushOpenSetSection0Cell.h"
#import "MJKCustomReturnSubModel.h"
#import "MJKPushDefaultListModel.h"

@interface MJKPushOpenSetSection0Cell ()
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitchButton;

@end

@implementation MJKPushOpenSetSection0Cell

- (void)awakeFromNib {
    [super awakeFromNib];
	
}
- (IBAction)openSwitchAction:(UISwitch *)sender {
    if (self.openSwitchBlock) {
        self.openSwitchBlock(sender.isOn);
    }
}

- (void)setListModel:(MJKPushDefaultListModel *)listModel{
    _listModel = listModel;
    self.titleLabel.text = listModel.NAME;
    self.openButton.hidden = YES;
    self.openSwitchButton.on = [listModel.ISCHECK isEqualToString:@"true"] ? YES : NO;
}

- (void)setModel:(MJKCustomReturnSubModel *)model {
	_model = model;
    self.openButton.hidden = YES;
	[self.openButton setBackgroundColor:model.I_TYPE == 0 ? kBackgroundColor : KNaviColor];
	[self.openButton setTitleNormal:model.I_TYPE == 0 ? @"启用" : @"关闭"];
	model.selected = model.I_TYPE == 0 ? NO : YES;
    self.openSwitchButton.on = model.I_TYPE == 0 ? NO : YES;
}

- (IBAction)openButtonAction:(UIButton *)sender {
    if (self.listModel != nil) {
        self.listModel.selected = !self.listModel.isSelected;
        if (self.selectButtonBlock) {
            self.selectButtonBlock(self.listModel.isSelected);
        }
    } else {
        self.model.selected = !self.model.isSelected;
        [sender setBackgroundColor:self.model.isSelected == NO ? kBackgroundColor : KNaviColor];
        [sender setTitleNormal:self.model.isSelected == NO ? @"启用" : @"关闭"];
        if (self.selectButtonBlock) {
            self.selectButtonBlock(self.model.isSelected);
        }
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKPushOpenSetSection0Cell";
	MJKPushOpenSetSection0Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
