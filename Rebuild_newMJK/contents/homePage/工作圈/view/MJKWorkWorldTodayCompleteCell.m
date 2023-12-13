//
//  MJKWorkWorldTodayCompleteCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/26.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKWorkWorldTodayCompleteCell.h"
#import "MJKWorkWorldObjectMapContentModel.h"

@interface MJKWorkWorldTodayCompleteCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end

@implementation MJKWorkWorldTodayCompleteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detailLabel.textColor = [UIColor darkGrayColor];
}

- (void)setModel:(MJKWorkWorldObjectMapContentModel *)model {
	_model = model;
	self.titleLabel.text = model.C_TYPE_DD_NAME;
    self.planCompLabel.text = [NSString stringWithFormat:@"%@%@",model.B_TOTAL_JH,model.UNIT];
	NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:model.B_TOTAL];
	NSRange strRange = {0,[str length]};
	[str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
	[str addAttribute:NSForegroundColorAttributeName value:KNaviColor range:strRange];
	self.countLabel.attributedText = str;
	self.unitLabel.text = model.UNIT;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKWorkWorldTodayCompleteCell";
	MJKWorkWorldTodayCompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
