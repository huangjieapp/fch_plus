//
//  MJKAddCheckAddressCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAddCheckAddressCell.h"

@implementation MJKAddCheckAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKAddCheckAddressCell";
	MJKAddCheckAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
