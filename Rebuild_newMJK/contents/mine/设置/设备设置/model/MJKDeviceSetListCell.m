//
//  MJKDeviceSetListCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/31.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKDeviceSetListCell.h"

#import "MJKFlowInstrumentSubModel.h"

@interface MJKDeviceSetListCell ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation MJKDeviceSetListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKFlowInstrumentSubModel *)model {
	_model = model;
	self.numberLabel.text = model.C_NUMBER;
	self.locationLabel.text = model.C_POSITION;
	
}

- (IBAction)editButtonAction:(UIButton *)sender {
	if (self.editButtonActionBlock) {
		self.editButtonActionBlock();
	}
}

- (IBAction)deleteButtonAction:(UIButton *)sender {
	if (self.deleteButtonActionBlock) {
		self.deleteButtonActionBlock();
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKDeviceSetListCell";
	MJKDeviceSetListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
