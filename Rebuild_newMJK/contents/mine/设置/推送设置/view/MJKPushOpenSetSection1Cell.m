//
//  MJKPushOpenSetSection1Cell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKPushOpenSetSection1Cell.h"

#import "MJKPushDefaultListModel.h"
#import "MJKClueListSubModel.h"

@interface MJKPushOpenSetSection1Cell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation MJKPushOpenSetSection1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKPushDefaultListModel *)model {
	_model = model;
	self.titleLabel.text = model.NAME;
	[self.selectButton setImage:[model.ISCHECK isEqualToString:@"true"] ? @"kuangselected" : @"kuang_off"];
	self.selectButton.selected = [model.ISCHECK isEqualToString:@"true"] ? YES : NO;
}

- (void)setJxModel:(MJKClueListSubModel *)jxModel {
    _jxModel = jxModel;
    self.titleLabel.text = jxModel.nickName;
    [self.selectButton setImage:jxModel.isSelected == YES ? @"kuangselected" : @"kuang_off"];
    self.selectButton.selected = jxModel.isSelected == YES ? YES : NO;
}

- (IBAction)selectButtonAction:(UIButton *)sender {
	sender.selected = !sender.isSelected;
    if (self.model != nil) {
        self.model.ISCHECK = sender.isSelected == YES ? @"true" : @"false";
    } else {
        self.jxModel.selected = sender.isSelected;
    }
    [sender setImage:sender.isSelected == YES ? @"kuangselected" : @"kuang_off"];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKPushOpenSetSection1Cell";
	MJKPushOpenSetSection1Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
