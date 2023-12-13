//
//  MJKCarSourcePathTableViewCell.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/19.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKCarSourcePathTableViewCell.h"

@implementation MJKCarSourcePathTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _statusLabel = [UILabel new];
        [self.contentView addSubview:_statusLabel];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(100);
        }];
        _statusLabel.textColor = [UIColor blackColor];
        _statusLabel.font = [UIFont systemFontOfSize:14.f];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.numberOfLines = 2;
        
        UIView *sepView = [UIView new];
        [self.contentView addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.statusLabel.mas_right);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(0.7);
        }];
        sepView.backgroundColor = [UIColor blackColor];
        
        UIImageView *dotImageView = [UIImageView new];
        [self.contentView addSubview:dotImageView];
        [dotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(sepView);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        dotImageView.image = [UIImage imageNamed:@"btn-轨迹小黄点"];
        
        _typeLabel = [UILabel new];
        [self.contentView addSubview:_typeLabel];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(dotImageView.mas_right);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(50);
        }];
        _typeLabel.textColor = [UIColor blackColor];
        _typeLabel.font = [UIFont systemFontOfSize:14.f];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        
        _contentLabel = [UILabel new];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.typeLabel.mas_right).offset(10);
            make.right.mas_equalTo(-10);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
        
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.f];
//        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        
        UIView *sepView1 = [UIView new];
        [self.contentView addSubview:sepView1];
        [sepView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeLabel.mas_right);
            make.centerY.equalTo(self.contentView);
            make.top.equalTo(self.typeLabel).offset(-10);
            make.bottom.equalTo(self.typeLabel).offset(10);
            make.width.mas_equalTo(0.7);
        }];
        sepView1.backgroundColor = [UIColor blackColor];
        
        
        
        
        
        
    }
    return self;
}

@end
