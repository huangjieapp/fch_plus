//
//  MJKClueMarketTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKClueMarketTableViewCell.h"

@interface MJKClueMarketTableViewCell ()
//@property (nonatomic, strong) MJKClueListSubModel *preModel;
//@property (nonatomic, strong) UIButton *preButton;
@end

@implementation MJKClueMarketTableViewCell

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
    if ([self.vcName isEqualToString:@"多选"]) {
        self.selectImageView.image = [UIImage imageNamed:subModel.isSelected == YES ? @"打钩.png" : @"未打钩.png"];
    }
	
}
static UIButton *preButton;
static MJKClueListSubModel *preModel;
static UIImageView *selectImageView1;
- (IBAction)selectButtonAction:(UIButton *)sender {
    
        _subModel.selected = !_subModel.isSelected;
    if ([self.vcName isEqualToString:@"多选"]) {
        self.selectImageView.image = [UIImage imageNamed:_subModel.isSelected == YES ? @"打钩.png" : @"未打钩.png"];
        if (self.chooseEmployeesBlock) {
            self.chooseEmployeesBlock(_subModel);
        }
    } else {
        if (_subModel.isSelected == YES) {
            preModel.selected = NO;
            if (preButton) {
                //            [preButton setImage:[UIImage imageNamed:@"未打钩.png"] forState:UIControlStateNormal];
                selectImageView1.image = [UIImage imageNamed:@"未打钩.png"];
                
            }
            
            //        [sender setImage:[UIImage imageNamed:@"打钩.png"] forState:UIControlStateNormal];
            self.selectImageView.image = [UIImage imageNamed:@"打钩.png"];
        }
        preModel = _subModel;
        selectImageView1 = self.selectImageView;
        preButton = sender;
        if (self.chooseEmployeesBlock) {
            self.chooseEmployeesBlock(_subModel);
        }
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKClueMarketTableViewCell";
	MJKClueMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
