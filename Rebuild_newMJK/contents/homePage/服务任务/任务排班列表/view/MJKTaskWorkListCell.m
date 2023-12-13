//
//  MJKTaskWorkListCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/30.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKTaskWorkListCell.h"

#import "MJKTaskWorkListModel.h"

@interface MJKTaskWorkListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@end

@implementation MJKTaskWorkListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListModel:(MJKTaskWorkListModel *)listModel {
	_listModel = listModel;
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:listModel.C_HEADIMGURL]];
	self.nameLabel.text = listModel.USER_NAME;
	self.highLabel.text = listModel.A01200_C_TASKSTATUS_0000;
	self.middleLabel.text = listModel.A01200_C_TASKSTATUS_0001;
	self.lowLabel.text = listModel.A01200_C_TASKSTATUS_0002;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKTaskWorkListCell";
	MJKTaskWorkListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
