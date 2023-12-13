//
//  MJKMessageHomeCollectionViewCell.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/18.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKMessageHomeCollectionViewCell.h"

@implementation MJKMessageHomeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *view = [UIView new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0);
            make.bottom.right.mas_equalTo(0);
        }];
        view.backgroundColor = [UIColor whiteColor];
        
        _countLabel = [UILabel new];
        [view addSubview:_countLabel];
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.centerY.equalTo(view).offset(-15);
        }];
        _countLabel.text = @"0";
        _countLabel.textColor = KNaviColor;
        _countLabel.font = [UIFont systemFontOfSize:16.f];
        
        _titleLabel = [UILabel new];
        [view addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.centerY.equalTo(view).offset(15);
        }];
        _titleLabel.text = @"0";
        _titleLabel.textColor = [UIColor colorWithHex:@"#777777"];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        
        
    }
    
    return self;
}
@end
