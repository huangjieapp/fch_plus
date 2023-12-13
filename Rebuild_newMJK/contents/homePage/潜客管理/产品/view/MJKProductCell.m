//
//  MJKProductCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKProductCell.h"

@implementation MJKProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)selectLikeProductButtonAction:(UIButton *)sender {
	if (self.clickLikeProductActionBlock) {
		self.clickLikeProductActionBlock();
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKProductCell";
	MJKProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}
@end
