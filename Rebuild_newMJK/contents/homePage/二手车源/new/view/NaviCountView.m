//
//  NaviCountView.m
//  match
//
//  Created by huangjie on 2022/7/27.
//

#import "NaviCountView.h"

@implementation NaviCountView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        imageView.image = [UIImage imageNamed:@"all_bg"];
        
        _countLabel = [UILabel new];
        [self addSubview:_countLabel];
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont systemFontOfSize:12.f];
        _countLabel.textColor = [UIColor darkGrayColor];
        _countLabel.text = @"总计:0";
    }
    return self;
}

- (void)dealloc {
    MyLog(@"销毁view----%s", __func__);
}

@end
