//
//  MJKMessageDetailCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/22.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKMessageDetailCell.h"
#import "MJKMessageDetailModel.h"

@interface MJKMessageDetailCell ()
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *seleteButton;

@end

@implementation MJKMessageDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKMessageDetailModel *)model {
	_model = model;
	self.messageImageView.image = [UIImage imageNamed:model.C_TYPE_DD_NAME];
	self.timeLabel.text = model.D_CREATE_TIME;
	self.contentLabel.text = model.X_CONTENT;
	if (model.D_RECIPIENTTIME.length > 0 || [model.C_STATE_DD_ID isEqualToString:@"A61700_C_STATE_0000"]) {
		self.badgeView.hidden = YES;
	} else {
		self.badgeView.hidden = NO;
	}
}

- (void)setIsDelete:(BOOL)isDelete {
	_isDelete = isDelete;
	if (isDelete == YES) {
		self.badgeView.hidden = YES;
		self.messageImageView.hidden = YES;
		self.seleteButton.hidden = NO;
	} else {
		self.seleteButton.hidden = YES;
		self.messageImageView.hidden = NO;
	}
	
}

- (void)setIsAllChoose:(BOOL)isAllChoose {
	_isAllChoose = isAllChoose;
	if (isAllChoose == YES) {
		self.model.selected = YES;
		[self.seleteButton setImage:@"打钩"];
	}
}

- (void)setCleanBadge:(BOOL)cleanBadge {
	_cleanBadge = cleanBadge;
	
}

- (IBAction)selectButtonAction:(UIButton *)sender {
	self.model.selected = !self.model.isSelected;
	if (self.model.isSelected == YES) {
		[sender setImage:@"打钩"];
	} else {
		[sender setImage:@"未打钩"];
	}
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKMessageDetailCell";
	MJKMessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
