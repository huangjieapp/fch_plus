//
//  OrderHeaderTableViewCell.m
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import "OrderHeaderTableViewCell.h"

@implementation OrderHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _headImageView = [UIImageView new];
        [self.contentView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(7);
            make.bottom.equalTo(self.contentView).offset(-7);
            make.left.mas_equalTo(17);
            make.width.height.mas_equalTo(50);
        }];
        _headImageView.image = [UIImage imageNamed:@"icon_add"];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.layer.cornerRadius = 5.f;
        _headImageView.layer.masksToBounds = YES;
        
        _headLabel = [UILabel new];
        [self.contentView addSubview:_headLabel];
        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.headImageView);
        }];
        _headLabel.textColor = [UIColor darkGrayColor];
        _headLabel.backgroundColor = kBackgroundColor;
        _headLabel.textAlignment = NSTextAlignmentCenter;
        _headLabel.layer.cornerRadius = 5;
        _headLabel.layer.masksToBounds = YES;
        
        
        _nameTextField = [UITextField new];
        [self.contentView addSubview:_nameTextField];
        [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImageView.mas_right).offset(17);
            make.right.mas_equalTo(-17);
            make.top.mas_equalTo(7);
            make.bottom.mas_equalTo(-7);
        }];
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.font = [UIFont systemFontOfSize:18.f];
        _nameTextField.textColor = [UIColor blackColor];
        _nameTextField.placeholder = @"请输入姓名";
        
        _wechatButton = [UIButton new];
        [self.contentView addSubview:_wechatButton];
        [_wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(-17);
        }];
        [_wechatButton setBackgroundImage:[UIImage imageNamed:@"订单微信"] forState:UIControlStateNormal];
        
        _messageButton = [UIButton new];
        [self.contentView addSubview:_messageButton];
        [_messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.wechatButton.mas_left).offset(-17);
        }];
        [_messageButton setBackgroundImage:[UIImage imageNamed:@"订单短信"] forState:UIControlStateNormal];
        
        _phoneButton = [UIButton new];
        [self.contentView addSubview:_phoneButton];
        [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.messageButton.mas_left).offset(-17);
        }];
        [_phoneButton setBackgroundImage:[UIImage imageNamed:@"订单电话"] forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)dealloc {
    MyLog(@"销毁cell----%s", __func__);
}

@end
