//
//  NaviSearchView.m
//  match
//
//  Created by huangjie on 2022/7/26.
//

#import "NaviSearchView.h"

@implementation NaviSearchView

- (instancetype)initWithView:(UIView *)currentView andReturnBlock:(void(^)(NSString *str))returnBlock {
    self = [super init];
    if (self) {
        
        [currentView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.centerX.equalTo(currentView);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(KScreenWidth * 0.6);
        }];
        
        self.layer.cornerRadius = 13;
        self.backgroundColor = [UIColor colorWithHex:@"#55ffffff"];
        
        UIImageView *iconImageView = [UIImageView new];
        [self addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(7);
            make.bottom.mas_equalTo(-7);
            make.width.mas_equalTo(iconImageView.mas_height);
        }];
        iconImageView.image = [UIImage imageNamed:@"放大镜"];
        
        
        _searchTextField = [UITextField new];
        [self addSubview:_searchTextField];
        [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(26);
            make.right.mas_equalTo(-10);
        }];
        _searchTextField.textColor = [UIColor darkGrayColor];
        _searchTextField.font = [UIFont  systemFontOfSize:12.f];
        
    }
    return self;
    
}

- (void)dealloc {
    MyLog(@"销毁view----%s", __func__);
}

@end
