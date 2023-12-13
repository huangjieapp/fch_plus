//
//  MJKOnlineHallPhotoTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKOnlineHallPhotoTableViewCell.h"

@implementation MJKOnlineHallPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)imageButtonClick:(UIButton *)sender {
	if (self.backClickImageButtonBlock) {
		self.backClickImageButtonBlock();
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKOnlineHallPhotoTableViewCell";
	MJKOnlineHallPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}
@end
