//
//  MJKOrderRecordTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKOrderRecordTableViewCell.h"

@implementation MJKOrderRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKOrderRecordTableViewCell";
	MJKOrderRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
			[cell setLayoutMargins:UIEdgeInsetsZero];
		}
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		
	}
	return cell;
	
}

@end
