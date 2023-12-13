//
//  MJKFunnelMoreViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/13.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKFunnelMoreViewCell.h"

@interface MJKFunnelMoreViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation MJKFunnelMoreViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKFunnelChooseModel *)model {
	_model = model;
	self.titleLabel.text = model.name;
	self.selectImageView.image = [UIImage imageNamed:model.isSelected == YES ? @"icon_1_highlight" : @"icon_1_normal"];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKFunnelMoreViewCell";
	MJKFunnelMoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}
@end
