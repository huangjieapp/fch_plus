//
//  MJKMessageCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKMessageCell.h"
#import "MJKMessageCenterModel.h"

@interface MJKMessageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *moduleImageView;
@property (weak, nonatomic) IBOutlet UILabel *moduleNmaeLabel;
@property (weak, nonatomic) IBOutlet UILabel *theLatestTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageLeftLayout;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation MJKMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKMessageCenterModel *)model {
	_model = model;
	self.moduleNmaeLabel.text = model.C_TYPE_DD_NAME;
	self.theLatestTimeLabel.text = model.X_CONTENT;
	self.timeLabel.text = model.D_SENDTIME;
	self.moduleImageView.image = [UIImage imageNamed:@"提醒消息"];
    if ([model.C_STATE_DD_ID isEqualToString:@"A61700_C_STATE_0001"]) {
        [self.moduleImageView pp_addDotWithColor:[UIColor redColor]];
        [self.moduleImageView pp_showBadge];
    } else {
        [self.moduleImageView pp_hiddenBadge];
    }
//	[self.moduleImageView pp_moveBadgeWithX:-2 Y:5];
	
    
	model.isSelected == YES ? [self.selectButton setImage:@"打钩"] : [self.selectButton setImage:@"未打钩"];
}

- (void)setIsRead:(BOOL)isRead {
	_isRead = isRead;
	if (isRead == YES) {
		self.selectButton.hidden = NO;
		self.headImageLeftLayout.constant = 50;
	} else {
		self.selectButton.hidden = YES;
		self.headImageLeftLayout.constant = 20;
	}
	
}

- (void)setIsAllChoose:(BOOL)isAllChoose {
	_isAllChoose = isAllChoose;
	if (isAllChoose == YES) {
		self.model.selected = YES;
		[self.selectButton setImage:@"打钩"];
	}
//	else {
//		self.model.selected = NO;
//		[self.selectButton setImage:@"未打钩"];
//	}
}

//- (void)setCleanBadge:(BOOL)cleanBadge {
//	_cleanBadge = cleanBadge;
//	if (cleanBadge == YES) {
//
//		[self.moduleImageView pp_addBadgeWithText:@"0"];
//	}
//}

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
	static NSString *ID = @"MJKMessageCell";
	MJKMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
