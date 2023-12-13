//
//  MJKCarSourceHomeTableViewCell.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/19.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKCarSourceHomeTableViewCell.h"

@implementation MJKCarSourceHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headLabel = [UILabel new];
        [self.contentView addSubview:_headLabel];
        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        _headLabel.textAlignment = NSTextAlignmentCenter;
        _headLabel.font = [UIFont systemFontOfSize:18.f];
        _headLabel.backgroundColor = kBackgroundColor;
        _headLabel.textColor = [UIColor colorWithHex:@"#333333"];
        
        _headImageView = [UIImageView new];
        [self.contentView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.headLabel);
        }];
        
        
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headLabel.mas_right).offset(10);
            make.top.equalTo(self.headLabel);
        }];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
        
        _rightLabel = [UILabel new];
        [self.contentView addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
            make.bottom.equalTo(self.titleLabel);
        }];
        _rightLabel.font = [UIFont systemFontOfSize:14.f];
        _rightLabel.textColor = [UIColor colorWithHex:@"#777777"];
        
        _subLabel = [UILabel new];
        [self.contentView addSubview:_subLabel];
        [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.equalTo(self.titleLabel);
        }];
        
        _subLabel.font = [UIFont systemFontOfSize:14.f];
        _subLabel.textColor = [UIColor colorWithHex:@"#777777"];
        
        _remarkLabel = [UILabel new];
        [self.contentView addSubview:_remarkLabel];
        [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subLabel.mas_bottom).offset(10);
            make.left.equalTo(self.subLabel);
        }];
        
        _remarkLabel.font = [UIFont systemFontOfSize:14.f];
        _remarkLabel.textColor = [UIColor colorWithHex:@"#777777"];
        
        
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        imageView.image = [UIImage imageNamed:@"all_bg"];
        
        _statusLabel = [UILabel new];
        [imageView addSubview:_statusLabel];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.bottom.mas_equalTo(0);
        }];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont systemFontOfSize:12.f];
        _statusLabel.textColor = KNaviColor;
        
        _shopLabel = [UILabel new];
        [self.contentView addSubview:_shopLabel];
        [_shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.equalTo(self.remarkLabel.mas_bottom);
            make.bottom.mas_equalTo(-10);
        }];
        _shopLabel.textAlignment = NSTextAlignmentCenter;
        _shopLabel.font = [UIFont systemFontOfSize:14.f];
        _shopLabel.textColor = [UIColor colorWithHex:@"#777777"];
        
    }
    return self;
}

@end
