//
//  SetSwitchTableViewCell.m
//  match
//
//  Created by huangjie on 2022/8/25.
//

#import "SetSwitchTableViewCell.h"

@implementation SetSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(17);
        }];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        
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
