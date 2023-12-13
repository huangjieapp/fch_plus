//
//  FunnelCustomTimeTableViewCell.m
//  match5.0
//
//  Created by huangjie on 2023/2/8.
//

#import "ProvincesAndCityTableViewCell.h"

#import "MJKFunnelChooseModel.h"

@implementation ProvincesAndCityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _selectButton = [UIButton new];
        [self.contentView addSubview:_selectButton];
        [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectButton.mas_right).offset(17);
            make.centerY.mas_equalTo(0);
            make.top.mas_equalTo(13);
            make.bottom.mas_equalTo(-13);
            make.right.mas_equalTo(-10);
        }];
        _titleLabel.font = KNomarlFont;
        _titleLabel.textColor = [UIColor colorWithHex:@"#000000"];
        _titleLabel.numberOfLines = 0;
        
       
        
        
    }
    return self;
}

@end
