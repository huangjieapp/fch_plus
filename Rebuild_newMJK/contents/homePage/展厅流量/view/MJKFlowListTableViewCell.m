//
//  MJKFlowListTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/7.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowListTableViewCell.h"
#import "MJKFlowListSecondSubModel.h"
#import "MJKFlowListViewController.h"

@implementation MJKFlowListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKFlowListSecondSubModel *)model {
	_model = model;
	if (self.isAgain == YES) {
		if (![_model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0001"]) {
			_model.selected = NO;
//			[self.tickButton setBackgroundImage:[UIImage imageNamed:@"未打钩.png"] forState:UIControlStateNormal];
//			[JRToast showWithText:@"只可选择未处理"];
		}
		[self.tickButton setBackgroundImage:[UIImage imageNamed:_model.isSelected ? @"打钩.png" : @"未打钩.png"] forState:UIControlStateNormal];
		self.handImageLayout.constant = 65;
		self.tickButton.hidden = NO;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		self.handImageLayout.constant = 20;
		self.tickButton.hidden = YES;
		self.selectionStyle = UITableViewCellSelectionStyleDefault;
	}
	
	
	
	if ([model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0003"]) {
		self.statusLabel.textColor = DBColor(114, 218, 73);
		
	} else if ([model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0004"]) {
		self.statusLabel.textColor = DBColor(62, 161, 183);
	} else if ([model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0001"]) {
		self.statusLabel.textColor = DBColor(248, 106, 95);
    } else if ([model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0007"]) {
        self.statusLabel.textColor = KNaviColor;
    }
    else {
		self.statusLabel.textColor = DBColor(189, 189, 189);
	}
	self.statusLabel.text = model.C_STATUS_DD_NAME;
	self.saleNameLabel.text = model.C_OWNER_ROLENAME;
	self.saleNameLabel.textColor = DBColor(139, 139, 139);
//    if (model.D_LEAVE_TIME.length>11) {
//        NSRange range=NSMakeRange(11, 5);
//        NSString*finishStr=[model.D_LEAVE_TIME substringWithRange:range];
	NSString *phoneStr;
	if (model.C_PHONE.length > 0) {
		if ([[NewUserSession  instance].configData.IS_TELEPHONEPRIVACY isEqualToString:@"0"]) {
			phoneStr = model.C_PHONE;
		} else {
			phoneStr = [model.C_PHONE stringByReplacingCharactersInRange:NSMakeRange(5, 3) withString:@"***"];
		}
	}
            self.titleLabel.text = [self.rootViewController isKindOfClass:[MJKFlowListViewController class]] ? [NSString stringWithFormat:@"%@ %@ %@人",model.D_ARRIVAL_TIME,  model.C_SOURCE_DD_NAME, model.I_PEPOLE_NUMBER] : [NSString stringWithFormat:@"%@ %@",model.D_ARRIVAL_TIME,  phoneStr];
//    }
	if ([model.C_STATUS_DD_NAME isEqualToString:@"未处理"]) {
		self.proceTimeLabel.text = @"处理时间:";
//		self.proceTimeLabel.text =  [NSString stringWithFormat:@"处理时间:%@",model.C_COMPOSE];
	} else {
		if (model.D_LEAVE_TIME.length>11) {
			NSString*finishStr=[model.D_LEAVE_TIME substringToIndex:16];
			self.proceTimeLabel.text =  [NSString stringWithFormat:@"处理时间:%@",finishStr];
		}
	}
	
	
	self.proceTimeLabel.textColor = self.saleNameLabel.textColor;
	
	if (model.C_HEADIMGURL.length > 0) {
//		self.handImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.C_HEADIMGURL]]];
		[self.handImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL]];
		self.firstNameLabel.hidden = YES;
		self.handImageView.hidden = NO;
		if ([model.C_STATUS_DD_NAME isEqualToString:@"已新增"] || [model.C_STATUS_DD_NAME isEqualToString:@"已关联"]) {
			self.firstNameLabel.text = [model.C_A41500_C_NAME substringToIndex:1];
			
			
		} else {
			if (model.C_PHONE.length > 0) {
				self.firstNameLabel.text = [model.C_PHONE substringFromIndex:7];
			}
			if ([self.rootViewController isKindOfClass:[MJKFlowListViewController class]]) {
				self.firstNameLabel.hidden = YES;
				self.handImageView.hidden = NO;
			}
			
		}
	} else {
		self.firstNameLabel.hidden = NO;
		self.handImageView.hidden = YES;
		if ([model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0003"] || [model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0004"]) {
			if (model.C_A41500_C_NAME.length > 0) {
				self.firstNameLabel.text = [model.C_A41500_C_NAME substringToIndex:1];
			}
			
			
			
		} else {
			if (model.C_PHONE.length > 0) {
                if (model.C_PHONE.length > 7) {
                    self.firstNameLabel.text = [model.C_PHONE substringFromIndex:7];
                } else {
                    self.firstNameLabel.text = model.C_PHONE;
                }
                
			}
			if ([self.rootViewController isKindOfClass:[MJKFlowListViewController class]]) {
				self.firstNameLabel.hidden = YES;
				self.handImageView.hidden = NO;
			}
			
		}
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKFlowListTableViewCell";
	MJKFlowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

- (IBAction)againButtonAction:(UIButton *)sender {
	_model.selected = !_model.isSelected;
	if (![_model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0001"] ) {
		_model.selected = NO;
		[sender setBackgroundImage:[UIImage imageNamed:@"未打钩.png"] forState:UIControlStateNormal];
		[JRToast showWithText:@"只可选择未处理"];
	}
	[sender setBackgroundImage:[UIImage imageNamed:_model.isSelected ? @"打钩.png" : @"未打钩.png"] forState:UIControlStateNormal];
	if (_model.isSelected == YES) {
		__block BOOL result = YES;//1
		[self.selectArray enumerateObjectsUsingBlock:^(MJKFlowListSecondSubModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			result *= obj.isSelected;
			NSLog(@"");
		}];
	}
	
}



@end
