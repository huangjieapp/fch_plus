//
//  MJKAttendanceMonthCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/8.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAttendanceMonthCell.h"
#import "MJKMonthStatementsContentModel.h"

@implementation MJKAttendanceMonthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKMonthStatementsModel *)model {
	_model = model;
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"logo-头像"]];
	self.nameLabel.text = model.C_NAME;
	self.addressLabel.text = model.C_ADDRESS;
	MJKMonthStatementsContentModel *subModel = model.statusContent[0];
	self.normalLabel.text = [NSString stringWithFormat:@"%@(次):%@",subModel.C_STATUS_DD_NAME, subModel.COUNT];
	for (int i = 1; i < model.statusContent.count; i++) {
		MJKMonthStatementsContentModel *subModel = model.statusContent[i];
		UILabel *titleLabel = self.titleLabelArray[i-1];
		UILabel *countLabel = self.countLabelArray[i-1];
		titleLabel.text = [subModel.C_STATUS_DD_NAME stringByAppendingString:@"(次)"];
		countLabel.text = subModel.COUNT;
	}
//	self.addressRightLayout.constant = self.normalLabel.frame.size.width + 20;
	CGSize size = [self.normalLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
	[self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(@(KScreenWidth - 70 - size.width - 20));
	}];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKAttendanceMonthCell";
	MJKAttendanceMonthCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
