//
//  ModuleCollectionViewCell.m
//  match
//
//  Created by huangjie on 2022/8/8.
//

#import "ModuleCollectionViewCell.h"

@implementation ModuleCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _bgView = [UIView new];
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(5);
            make.bottom.right.mas_equalTo(-5);
        }];
        
        _moduleImageView = [UIImageView new];
        [self.bgView addSubview:_moduleImageView];
        [_moduleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.centerX.equalTo(self.bgView);
        }];
        
        _moduleLabel = [UILabel new];
        [self.bgView addSubview:_moduleLabel];
        [_moduleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-8);
            make.centerX.equalTo(self.bgView);
        }];
        _moduleLabel.font = [UIFont systemFontOfSize:12.f];
        _moduleLabel.textColor = [UIColor darkGrayColor];
        
        _moduleSelectImageView = [UIImageView new];
        [self.bgView addSubview:_moduleSelectImageView];
        [_moduleSelectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.equalTo(self.bgView).offset(-8);
        }];
        
        
    }
    return self;
}

- (void)setIsCheck:(BOOL)isCheck {
    if (isCheck == YES) {
        self.bgView.layer.borderWidth = 0.5f;
        self.bgView.layer.borderColor = [UIColor colorWithHex:@"#DDDDDD"].CGColor;
    } else {
        self.bgView.layer.borderWidth = 0;
        self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}
@end
