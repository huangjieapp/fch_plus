//
//  CustomerRemarkTableViewCell.m
//  match
//
//  Created by huangjie on 2022/8/1.
//

#import "CustomerRemarkTableViewCell.h"


@implementation CustomerRemarkTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.top.mas_equalTo(7);
        }];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        
        _mustLabel = [UILabel new];
        [self.contentView addSubview:_mustLabel];
        [_mustLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right);
            make.top.equalTo(self.titleLabel);
        }];
        _mustLabel.text = @"*";
        _mustLabel.textColor = [UIColor redColor];
        _mustLabel.hidden = YES;
        
        _textView = [UITextView new];
        [self.contentView addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
            make.right.mas_equalTo(-17);
            make.height.mas_equalTo(80);
            make.bottom.mas_equalTo(-7);
        }];
        _textView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.cornerRadius = 5.f;
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请输入内容";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        [_textView addSubview:placeHolderLabel];
         
        // 同步字体
        _textView.font = [UIFont systemFontOfSize:14.f];
        placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
        [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
       
        
    }
    return self;
}

- (void)dealloc {
    MyLog(@"销毁cell----%s", __func__);
}

@end
