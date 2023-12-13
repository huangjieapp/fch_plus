//
//  MJKJFDetailCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKJFDetailCell.h"
#import "MJKJFDetailModel.h"

@interface MJKJFDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *jfLabelArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabelArray;

@end

@implementation MJKJFDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setJfDetailModel:(MJKJFDetailModel *)jfDetailModel {
	_jfDetailModel = jfDetailModel;
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, (jfDetailModel.personalDetails.count / 4) * 60)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:14.f];
    nameLabel.text = jfDetailModel.C_NAME;
    [self addSubview:nameLabel];
	self.nameLabel.text = jfDetailModel.C_NAME;
	for (int i = 0; i < jfDetailModel.personalDetails.count; i++) {
		MJKJFSubModel *subModel = jfDetailModel.personalDetails[i];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(60 + ((i % 4) * ((KScreenWidth - 60) / 4)), (i / 4) * 60 , (KScreenWidth - 60) / 4, 60)];
        [self addSubview:bgView];
        
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (KScreenWidth - 60) / 4, 40)];
        titleLabel.layer.borderWidth = 1;
        titleLabel.layer.borderColor = kBackgroundColor.CGColor;
        titleLabel.numberOfLines = 2;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:subModel.C_TYPE_DD_NAME];
        [str setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.f]} range:NSMakeRange(str.length - 6, 6)];
        titleLabel.attributedText = str;
        titleLabel.textColor = [UIColor lightGrayColor];
        [bgView addSubview:titleLabel];
        
        UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, (KScreenWidth - 60) / 4, 20)];
        countLabel.layer.borderWidth = 1;
        countLabel.layer.borderColor = kBackgroundColor.CGColor;
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.textColor = [UIColor blackColor];
        countLabel.font = [UIFont systemFontOfSize:14.f];
        countLabel.textColor = [UIColor lightGrayColor];
        countLabel.text = subModel.I_INTEGRAL;
        [bgView addSubview:countLabel];
	}
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKJFDetailCell";
	MJKJFDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}
@end
