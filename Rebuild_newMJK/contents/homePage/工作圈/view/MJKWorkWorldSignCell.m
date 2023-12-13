//
//  MJKWorkWorldSignCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKWorkWorldSignCell.h"

@implementation MJKWorkWorldSignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKWorkWorldSignCell";
	MJKWorkWorldSignCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
