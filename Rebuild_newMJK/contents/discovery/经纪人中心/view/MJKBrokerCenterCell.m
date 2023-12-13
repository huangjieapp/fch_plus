//
//  MJKBrokerCenterCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/29.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKBrokerCenterCell.h"
#import "CGCCustomModel.h"

@interface MJKBrokerCenterCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *lockLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromSalerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *linkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UIImageView *allbgImageView;

@property (weak, nonatomic) IBOutlet UILabel *bandingLabel;

@end

@implementation MJKBrokerCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)brokerCellWithModel:(CGCCustomModel *)model {
    if (model.C_HEADIMGURL.length > 0) {
        self.headImageView.hidden = NO;
        self.firstNameLabel.hidden = YES;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL]];
    } else {
        self.headImageView.hidden = YES;
        self.headImageView.hidden = NO;
    }
    self.firstNameLabel.text = model.C_NAME.length > 0 ? [model.C_NAME substringToIndex:1] : @"";
    self.firstNameLabel.backgroundColor = kBackgroundColor;
    self.nameLabel.text = [NSString stringWithFormat:@"%@   %@",model.C_NAME, model.C_LEVEL_DD_NAME];
    if (model.C_FSLX_DD_NAME.length > 0) {
        self.typeLabel.text = model.C_FSLX_DD_NAME;
        self.allbgImageView.hidden = NO;
    } else {
        self.allbgImageView.hidden = YES;
    }
    if ([model.C_STATUS_DD_NAME isEqualToString:@"未绑定"]) {
        self.linkImageView.hidden = YES;
    } else {
        self.linkImageView.hidden = NO;
    }
    self.addressLabel.text = model.C_ENGLISHNAME;
//    self.lockLabel.text = model.C_STATUS_DD_NAME;
    self.scoreLabel.text = [NSString stringWithFormat:@"积分:%@",model.I_INTEGRAL];
    self.scoreLabel.hidden = YES;
    self.fromSalerLabel.text = model.C_OWNER_ROLENAME;//C_CREATOR_ROLENAME
    self.starImageView.image = [UIImage imageNamed:[model.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"] ? @"星标" : @"未星标"];
//    if ([model.C_TYPE_DD_ID isEqualToString:@"A47700_C_TYPE_0001"]) {
//        self.typeLabel.textColor = COLOR_RGB(0xF0AD4E);//橙
//    } else if ([model.C_TYPE_DD_ID isEqualToString:@"A47700_C_TYPE_0002"]) {
//
//    }else if ([model.C_TYPE_DD_ID isEqualToString:@"A47700_C_TYPE_0003"]) {
//        self.typeLabel.textColor = COLOR_RGB(0x4BB0C4);//蓝
//    }else if ([model.C_TYPE_DD_ID isEqualToString:@"A47700_C_TYPE_0004"]) {
//        self.typeLabel.textColor = COLOR_RGB(0x5cb85c);//绿
//    }else if ([model.C_TYPE_DD_ID isEqualToString:@"A47700_C_TYPE_0005"]) {
//        self.typeLabel.textColor = COLOR_RGB(0xFF5757);//红
//    } else {
//        self.typeLabel.textColor = COLOR_RGB(0xF0AD4E);//橙
//    }
    if ([model.C_FSLX_DD_ID isEqualToString:@"A47700_C_FSLX_0000"]) {
        self.typeLabel.textColor = COLOR_RGB(0xFF5757);//红
    } else if ([model.C_FSLX_DD_ID isEqualToString:@"A47700_C_FSLX_0002"]) {
        self.typeLabel.textColor = COLOR_RGB(0xF0AD4E);//橙
    }else if ([model.C_FSLX_DD_ID isEqualToString:@"A47700_C_FSLX_0001"]) {
        self.typeLabel.textColor = COLOR_RGB(0x4BB0C4);//蓝
    }else {
        self.typeLabel.textColor = COLOR_RGB(0xF0AD4E);//橙
    }
    self.bandingLabel.text = model.C_STATUS_DD_NAME;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKBrokerCenterCell";
	MJKBrokerCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
	}
	return cell;
	
}
@end
