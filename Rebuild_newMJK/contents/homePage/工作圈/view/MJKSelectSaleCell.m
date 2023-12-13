//
//  MJKClueMarketTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKSelectSaleCell.h"

#import "MJKClueListSubModel.h"
@interface MJKSelectSaleCell ()
//@property (nonatomic, strong) MJKClueListSubModel *preModel;
//@property (nonatomic, strong) UIButton *preButton;
@end

@implementation MJKSelectSaleCell

- (void)awakeFromNib {
	[super awakeFromNib];
	self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
}

- (void)setSubModel:(MJKClueListSubModel *)subModel {
	_subModel = subModel;
	if (self.subModel.avatar.length > 0) {
		//加载图片有延迟，用多线程
		//		dispatch_async(dispatch_get_global_queue(0, 0), ^{
		//			NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.subModel.C_HEADPIC]];
		//			dispatch_async(dispatch_get_main_queue(), ^{
		//				self.picImageView.image = [UIImage imageWithData:data];
		//			});
		//		});
		[self.picImageView sd_setImageWithURL:[NSURL URLWithString:self.subModel.avatar]];
	} else {
		self.picImageView.image = [UIImage imageNamed:@"logo-2.png"];
	}
	self.nameLabel.text = self.subModel.nickName;
	
}
//static UIButton *preButton1;
//static MJKClueListSubModel *preModel1;
//static UIImageView *selectImageView11;
- (IBAction)selectButtonAction:(UIButton *)sender {
	_subModel.selected = !_subModel.isSelected;
	if (_subModel.isSelected == YES) {
//		preModel1.selected = NO;
//		if (preButton1) {
//			//            [preButton1 setImage:[UIImage imageNamed:@"未打钩.png"] forState:UIControlStateNormal];
//			selectImageView11.image = [UIImage imageNamed:@"未打钩.png"];
//
//		}
		
		//        [sender setImage:[UIImage imageNamed:@"打钩.png"] forState:UIControlStateNormal];
		self.selectImageView.image = [UIImage imageNamed:@"打钩.png"];
	} else {
		self.selectImageView.image = [UIImage imageNamed:@"未打钩.png"];
	}
//	preModel1 = _subModel;
//	selectImageView11 = self.selectImageView;
//	preButton1 = sender;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKSelectSaleCell";
	MJKSelectSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		
	}
	return cell;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

@end
