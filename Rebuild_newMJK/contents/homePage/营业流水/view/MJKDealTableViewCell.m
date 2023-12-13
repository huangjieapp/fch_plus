//
//  MJKDealTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/3/30.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKDealTableViewCell.h"

@implementation MJKDealTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKDealTableViewCell";
	MJKDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
