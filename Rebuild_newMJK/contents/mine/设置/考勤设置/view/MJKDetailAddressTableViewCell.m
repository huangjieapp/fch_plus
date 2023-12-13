//
//  MJKDetailAddressTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/6.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKDetailAddressTableViewCell.h"

@implementation MJKDetailAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDic:(NSDictionary *)dic {
	_dic = dic;
	self.titleLabel.text = [NSString stringWithFormat:@"考勤地点%ld",self.indexPath.row - 1];
	self.addressLabel.text = dic[@"C_NAME"];
}

- (void)setAddressModel:(MJKCheckDetailAddressModel *)addressModel {
	_addressModel = addressModel;
	self.titleLabel.text = [NSString stringWithFormat:@"考勤地点%ld",self.indexPath.row - 1];
	self.addressLabel.text = addressModel.C_NAME;
}

- (IBAction)deleteButtonAction:(UIButton *)sender {
	if (self.deleteAddressBlock) {
		self.deleteAddressBlock();
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKDetailAddressTableViewCell";
	MJKDetailAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}
@end
