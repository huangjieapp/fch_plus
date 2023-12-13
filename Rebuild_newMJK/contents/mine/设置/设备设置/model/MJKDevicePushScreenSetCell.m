//
//  MJKDevicePushScreenSetCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/7.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKDevicePushScreenSetCell.h"

#import "MJKFlowInstrumentSubModel.h"

@interface MJKDevicePushScreenSetCell ()
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation MJKDevicePushScreenSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKFlowInstrumentSubModel *)model {
	_model = model;
	self.locationNameLabel.text = model.C_POSITION;
	if ([model.ISCHECK isEqualToString:@"true"]) {
		[self.selectButton setImage:@"kuangselected"];
	} else {
		[self.selectButton setImage:@"kuang_off"];
	}
}
- (IBAction)selectButtonAction:(UIButton *)sender {
	if ([self.model.ISCHECK isEqualToString:@"true"]) {
		self.model.ISCHECK = @"false";
		[self.selectButton setImage:@"kuang_off"];
	} else {
		self.model.ISCHECK = @"true";
		[self.selectButton setImage:@"kuangselected"];
	}
	if (self.selectBackBlock) {
		self.selectBackBlock();
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKDevicePushScreenSetCell";
	MJKDevicePushScreenSetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
