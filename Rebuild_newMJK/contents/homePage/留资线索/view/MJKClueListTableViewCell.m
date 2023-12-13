//
//  MJKClueListTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MJKClueListTableViewCell.h"

@interface MJKClueListTableViewCell ()
@property (nonatomic, strong) MJKClueListMainSecondModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateLabelWidth;

@end

@implementation MJKClueListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.stateLabel.textColor = DBColor(248, 106, 95);;
	self.custFirstName.textColor = DBColor(92, 92, 92);
	self.custFirstName.backgroundColor = DBColor(207, 207, 207);
	self.sendDowntime.textColor = DBColor(142, 142, 142);
	self.approachLabel.textColor = self.saleName.textColor = DBColor(150, 150, 150);
	self.custFirstName.layer.cornerRadius = 5.0f;
	self.custFirstName.layer.masksToBounds = YES;
	self.sepLabel.backgroundColor = DBColor(188, 187, 194);
}

- (void)updateCellWithDatas:(MJKClueListMainSecondModel *)model {
	self.model = model;
	self.custName.text = model.C_NAME;
    self.regionLabel.text = [NSString stringWithFormat:@"%@ %@",model.C_PURPOSE, model.X_REMARK];
	if (model.C_NAME.length > 0) {
		self.custFirstName.text = [model.C_NAME substringToIndex:1];
	} else {
		self.custFirstName.text = @"";
	}
	if (self.isAgain == YES) {
		if ([_model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0003"] || [_model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0006"] || [_model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0002"] || [_model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0005"]) {
			[self.againImageView setBackgroundImage:[UIImage imageNamed:_model.isSelected ? @"打钩.png" : @"未打钩.png"] forState:UIControlStateNormal];
		} else {
			_model.selected = NO;
			[self.againImageView setBackgroundImage:[UIImage imageNamed:@"未打钩.png"] forState:UIControlStateNormal];
//			[JRToast showWithText:@"此状态不可以选择"];
		}
		
//		if ([_model.C_STATUS_DD_NAME isEqualToString:@"有意向"] /*|| [_model.C_STATUS_DD_NAME isEqualToString:@"再下发"] */|| [_model.C_STATUS_DD_NAME isEqualToString:@"再激活"]  || [_model.C_STATUS_DD_NAME isEqualToString:@"无意向"]) {
//			_model.selected = NO;
//			[self.againImageView setBackgroundImage:[UIImage imageNamed:@"未打钩.png"] forState:UIControlStateNormal];
//		}
//		[self.againImageView setBackgroundImage:[UIImage imageNamed:_model.isSelected ? @"打钩.png" : @"未打钩.png"] forState:UIControlStateNormal];
		self.firstNameImageLayout.constant = 50;
		self.againImageView.hidden = NO;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		self.firstNameImageLayout.constant = 20;
		self.againImageView.hidden = YES;
		self.selectionStyle = UITableViewCellSelectionStyleDefault;
	}
//    self.stateLabel.text = [NSString stringWithFormat:@"%@ %@",model.C_STATUS_DD_NAME, model.C_CUSTOMERSTATUS_DD_NAME];
    self.stateLabel.text = model.C_STATUS_DD_NAME;
    CGRect rect = [model.C_STATUS_DD_NAME boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil];
    if (rect.size.width > 90) {
        self.stateLabelWidth.constant = rect.size.width + 10;
    } else {
        self.stateLabelWidth.constant = 90;
    }
    
	if ([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0001"]) {
		self.stateLabel.textColor = COLOR_RGB(0x79D977);
	} else if (([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0007"])) {
		self.stateLabel.textColor = COLOR_RGB(0x62F4CD);
	} else if (([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0006"])) {
		self.stateLabel.textColor = COLOR_RGB(0x5CB85C);
	} else if (([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0005"])) {
		self.stateLabel.textColor = COLOR_RGB(0xFF5757);
	} else if (([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0004"])) {
		self.stateLabel.textColor = COLOR_RGB(0x5DC2CA);
	} else if (([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0003"])) {
		self.stateLabel.textColor = COLOR_RGB(0xFC7E6F);
	} else if (([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0002"])) {
        if ([model.IS_FOLLOW isEqualToString:@"1"]) {
            self.stateLabel.textColor = COLOR_RGB(0x79D977);
        } else {
        self.stateLabel.textColor = COLOR_RGB(0xF0AD4E);
        }
	} else if (([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0008"])) {
		self.stateLabel.textColor = COLOR_RGB(0xFF939F);
	} else if (([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0000"])) {
		self.stateLabel.textColor = COLOR_RGB(0xB5B5B5);
	}
//	self.stateLabel.textColor = [self.stateLabel.text isEqualToString:@"有意向"] ? DBColor(114, 218, 73) : [self.stateLabel.text isEqualToString:@"无意向"] ? [UIColor grayColor] : DBColor(248, 106, 95);;
	self.saleName.text = model.C_OWNER_ROLENAME;
	self.approachLabel.text = [NSString stringWithFormat:@"%@-%@-%@",model.C_CLUESOURCE_DD_NAME,model.C_A41200_C_NAME,model.C_REGION];
	if ([model.C_SEX_DD_NAME isEqualToString:@"男"]) {
		self.custSexImageView.image = [UIImage imageNamed:@"iv_man.png"];
	} else if ([model.C_SEX_DD_NAME isEqualToString:@"女"]) {
		self.custSexImageView.image = [UIImage imageNamed:@"iv_women.png"];
	}
	
}

- (IBAction)againImageAction:(UIButton *)sender {
	NSMutableArray *numberArr = [NSMutableArray array];
	[numberArr removeAllObjects];
	for (MJKClueListMainSecondModel *model in self.selectArray) {
		if (model.isSelected == YES) {
			[numberArr addObject:model];
		}
	}
	if (numberArr.count >= 20) {
		[JRToast showWithText:@"最多选择20条"];
		return;
	}
	_model.selected = !_model.isSelected;
    //有意向、无意向、再激活不可重新指派
	if ([_model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0003"] || [_model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0006"] || [_model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0002"] || [_model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0005"]) {
		[sender setBackgroundImage:[UIImage imageNamed:_model.isSelected ? @"打钩.png" : @"未打钩.png"] forState:UIControlStateNormal];
	} else {
		_model.selected = NO;
		[sender setBackgroundImage:[UIImage imageNamed:@"未打钩.png"] forState:UIControlStateNormal];
		[JRToast showWithText:@"此状态不可以选择"];
	}
	
	
	if (_model.isSelected == YES) {
		__block BOOL result = YES;//1
		[self.selectArray enumerateObjectsUsingBlock:^(MJKClueListMainSecondModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			result *= obj.isSelected;
			NSLog(@"");
		}];
	}
	
	
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKClueListTableViewCell";
	MJKClueListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
