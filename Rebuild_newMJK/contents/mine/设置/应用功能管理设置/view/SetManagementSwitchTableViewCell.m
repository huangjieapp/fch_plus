//
//  SetSwitchTableViewCell.m
//  match
//
//  Created by huangjie on 2022/8/25.
//

#import "SetManagementSwitchTableViewCell.h"

@implementation SetManagementSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headImageView = [UIImageView new];
        [self.contentView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(17);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.headImageView.mas_right).offset(10);
        }];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont  systemFontOfSize:14.f];
        
        _switchButton = [UISwitch new];
        [self.contentView addSubview:_switchButton];
        [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(-17);
        }];
        _switchButton.onTintColor = KNaviColor;
    }
    return self;
}

@end
