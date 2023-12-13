//
//  MJKJxInfoNameTableViewCell.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/10.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKJxInfoNameTableViewCell.h"

@implementation MJKJxInfoNameTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(100);
        }];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


@end
