//
//  MJKDeviationTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/13.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKDeviationTableViewCell.h"

@implementation MJKDeviationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKDeviationTableViewCell";
	MJKDeviationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}
@end
