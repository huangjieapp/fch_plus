//
//  CommentBottomView.m
//  match5.0
//
//  Created by huangjie on 2023/6/11.
//

#import "CommentBottomView.h"


@interface CommentBottomView ()

@end

@implementation CommentBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _commentButton = [UIButton new];
        [self addSubview:_commentButton];
        [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@5);
            make.bottom.equalTo(@(-5));
            make.left.equalTo(@5);
        }];
        [_commentButton setBackgroundColor:[UIColor  colorWithHexString:@"#DDD"]];
        [_commentButton setTitle:@"发表评论" forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor  colorWithHexString:@"#777"] forState:UIControlStateNormal];
        _commentButton.titleLabel.font = KNomarlFont;
        [_commentButton setImage:[UIImage imageNamed:@"跟进"] forState:UIControlStateNormal];
        [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
//        [[_commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
//            
//        }];
        
        _operationButton = [UIButton new];
        [self addSubview:_operationButton];
        [_operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@5);
            make.bottom.equalTo(@(-5));
            make.left.equalTo(self.commentButton.mas_right).offset(5);
            make.width.equalTo(@100);
            make.right.equalTo(@(-5));
        }];
        [_operationButton setBackgroundColor:KNaviColor];
        [_operationButton setTitle:@"修改" forState:UIControlStateNormal];
        [_operationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _commentButton.layer.cornerRadius = _operationButton.layer.cornerRadius = 5.f;
    }
    return self;
}
@end
