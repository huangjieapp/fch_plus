//
//  MJKPublicMessageListCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/14.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKPublicMessageListCell.h"

#import "CGCTalkModel.h"

@interface MJKPublicMessageListCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation MJKPublicMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CGCTalkModel *)model {
	_model = model;
	self.titleLabel.text = model.C_NAME;
	self.contentLabel.text = model.X_PICCONTENT;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKPublicMessageListCell";
	MJKPublicMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

+ (CGFloat)cellHeight:(CGCTalkModel *)model {
	CGSize size = [model.X_PICCONTENT boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
	return size.height + 44;
}

@end
