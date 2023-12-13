//
//  MJKJxInfoTableViewCell.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/10.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKJxInfoTableViewCell.h"

@implementation MJKJxInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}


- (void)setArr:(NSArray *)arr {
    _arr = arr;
    for (int i = 0; i < arr.count; i++) {
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.mas_equalTo(i * 60);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(60);
        }];
        label.text = arr[i];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textAlignment = NSTextAlignmentCenter;
        
    }
    
    _timeLabel = [UILabel new];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(arr.count * 60);
        make.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(180, 40));
    }];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.font = [UIFont systemFontOfSize:14.f];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
}
@end
