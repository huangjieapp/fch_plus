//
//  MJKCustomerLabelCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/15.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKCustomerLabelCell.h"

#import "MJKCustomerTheLabelModel.h"
#import "MJKCustomerTheLabelSubModel.h"

@interface MJKCustomerLabelCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelViewHeight;
///** MJKCustomerTheLabelModel*/
//@property (nonatomic, strong) MJKCustomerTheLabelModel *model;
@end

@implementation MJKCustomerLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKCustomerTheLabelModel *)model {
	_model = model;
	self.titleLabel.text = model.type_name;
	[self.addButton setBackgroundColor:[UIColor colorWithHexString:model.C_COLOR_DD_ID]];
	
	CGFloat x = 0;
	CGFloat y = 44 + 10;
	
	for (int i = 0; i < model.content.count; i++) {
		MJKCustomerTheLabelSubModel *subModel = model.content[i];
		CGSize size = [subModel.C_NAME boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 25) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
		
		if (x + size.width + 35 + 10 + 10 > KScreenWidth) {
			x = 0;
			y += 40;
		}
		
		UILabel *label = [[UILabel alloc]init];
		[self.contentView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(y);
			make.left.mas_equalTo(x + 10);
			make.width.mas_equalTo(size.width + 20);
			make.height.mas_equalTo(25);
		}];
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:12.f];
		label.text = subModel.C_NAME;
		label.textColor = [UIColor colorWithHexString:subModel.C_COLOR_DD_ID];
		label.layer.borderColor = [UIColor colorWithHexString:subModel.C_COLOR_DD_ID].CGColor;
		label.layer.borderWidth = 1.f;
		
		//每个label的删除按钮
		UIButton *button = [[UIButton alloc]init];
		[self.contentView addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.mas_equalTo(label.mas_top);
			make.centerX.mas_equalTo(label.mas_right);
			make.width.height.mas_equalTo(15);
		}];
		[button setBackgroundImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(deleteTheLabelAction:)];
		button.tag = 100 + i;
		
		x += size.width + 35 + 10;
		
		
		if (i == model.content.count - 1) {
			if (x + size.width + 35 + 10 + 10 > KScreenWidth) {
				x = 0;
				y += 40;
				[self.addButton mas_updateConstraints:^(MASConstraintMaker *make) {
					make.left.mas_equalTo(10);
					make.centerY.mas_equalTo(label.mas_centerY).mas_offset(44);
				}];
			} else {
				[self.addButton mas_updateConstraints:^(MASConstraintMaker *make) {
					make.left.mas_equalTo(label.mas_right).mas_offset(10);
					make.centerY.mas_equalTo(label.mas_centerY);
				}];
			}
		}
	}
}
//删除单个标签
- (void)deleteTheLabelAction:(UIButton *)sender {
	MJKCustomerTheLabelSubModel *subModel = self.model.content[sender.tag - 100];
	if (self.deleteTheLabelBlock) {
		self.deleteTheLabelBlock(subModel.C_ID);
	}
}
//删除标签类型
- (IBAction)deleteButtonAction:(UIButton *)sender {
	if (self.deleteCustomerLabelBlock) {
		self.deleteCustomerLabelBlock();
	}
}
//新增单个标签
- (IBAction)addButtonAction:(UIButton *)sender {
	if (self.addLabelBlock) {
		self.addLabelBlock(sender);
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKCustomerLabelCell";
	MJKCustomerLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

+ (CGFloat)heightForCell:(MJKCustomerTheLabelModel *)model {
	CGFloat x = 0;
	CGFloat y = 44 + 10;
	
	for (int i = 0; i < model.content.count; i++) {
		MJKCustomerTheLabelSubModel *subModel = model.content[i];
		CGSize size = [subModel.C_NAME boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 25) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
		x += size.width + 35 + 10;
		if (x + size.width + 35 + 10 + 10 > KScreenWidth) {
			x = 0;
			y += 40;
		}
	}
	CGFloat height = y + 40;
	return height;
}

@end
