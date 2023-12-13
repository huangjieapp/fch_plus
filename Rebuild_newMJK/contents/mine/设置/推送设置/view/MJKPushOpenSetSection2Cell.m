//
//  MJKPushOpenSetSection2Cell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKPushOpenSetSection2Cell.h"
#import "MJKClueListSubModel.h"

@interface MJKPushOpenSetSection2Cell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation MJKPushOpenSetSection2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKClueListSubModel *)model {
	_model = model;
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADPIC]];
	self.nameLabel.text = model.user_name;
}

- (void)setNModel:(MJKClueListSubModel *)nModel {
    _nModel = nModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:nModel.avatar]];
    self.nameLabel.text = nModel.nickName;
}


//选择的人
- (void)setCustomerArray:(NSArray *)customerArray {
	_customerArray = customerArray;
	for (NSString *userId in customerArray) {
		if ([userId isEqualToString:self.model.user_id]) {
			[self.selectButton setImage:@"kuangselected"];
			self.model.selected = YES;
		}
	}
}

- (void)setNCustomerArray:(NSArray *)nCustomerArray {
    _nCustomerArray = nCustomerArray;
    for (NSString *userId in nCustomerArray) {
        if ([userId isEqualToString:self.nModel.u031Id]) {
            [self.selectButton setImage:@"kuangselected"];
            self.nModel.selected = YES;
        }
    }
}

- (IBAction)selectButtonAction:(UIButton *)sender {
    if (self.model != nil) {
        self.model.selected = !self.model.isSelected;
        [sender setImage:self.model.isSelected == YES ? @"kuangselected" : @"kuang_off"];
    } else {
        self.nModel.selected = !self.nModel.isSelected;
        [sender setImage:self.nModel.isSelected == YES ? @"kuangselected" : @"kuang_off"];
    }
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKPushOpenSetSection2Cell";
	MJKPushOpenSetSection2Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
