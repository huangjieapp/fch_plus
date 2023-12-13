//
//  MJKHomePagePersonCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKHomePagePersonNewCell.h"

#import "NoticeInfoModel.h"
#import "ADRollView.h"
#import "ADRollModel.h"
#import "MJKPayModel.h"
#import "MJKHomePageJXModel.h"
#import "NoticeInfoDetailViewController.h"

@interface MJKHomePagePersonNewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopLabel;

@end

@implementation MJKHomePagePersonNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
	
	self.titleLabel.text = [NSString stringWithFormat:@"%@",[NewUserSession instance].user.nickName];
    self.shopLabel.text = [NSString stringWithFormat:@"%@",[NewUserSession instance].user.C_LOCNAME];
	
	[self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:[NewUserSession instance].user.avatar] placeholderImage:[UIImage imageNamed:@"icon_set_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		
	}];
}
- (IBAction)codeButtonAction:(id)sender {
    if (self.codeButtonActionBlock) {
        self.codeButtonActionBlock();
    }
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKHomePagePersonNewCell";
    MJKHomePagePersonNewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
