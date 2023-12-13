//
//  MJKWorkReportRemarkCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/26.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKWorkReportRemarkCell.h"

@implementation MJKWorkReportRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.labelLayout.constant =self.frame.size.width - KScreenWidth;
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKWorkReportRemarkCell";
	MJKWorkReportRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		//		if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		//			[cell setLayoutMargins:UIEdgeInsetsZero];
		//		}
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
