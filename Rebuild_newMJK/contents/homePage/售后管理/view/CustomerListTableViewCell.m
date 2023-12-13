//
//  CustomerListTableViewCell.m
//  match
//
//  Created by huangjie on 2022/7/27.
//

#import "CustomerListTableViewCell.h"

@implementation CustomerListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _chooseButton = [UIButton new];
        [self.contentView addSubview:_chooseButton];
        [_chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@17);
            make.centerY.equalTo(@0);
            make.width.height.mas_equalTo(30);
        }];
        [_chooseButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [_chooseButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        _chooseButton.hidden = YES;
        
        _headImageView = [UIImageView new];
        [self.contentView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@17);
            make.top.equalTo(@10);
            make.width.height.equalTo(@60);
        }];
        _headImageView.layer.cornerRadius = 5;
        _headImageView.layer.masksToBounds = YES;
        
        _headLabel = [UILabel new];
        [self.contentView addSubview:_headLabel];
        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(_headImageView);
        }];
        _headLabel.textColor = [UIColor darkGrayColor];
        _headLabel.backgroundColor = kBackgroundColor;
        _headLabel.textAlignment = NSTextAlignmentCenter;
        _headLabel.layer.cornerRadius = 5;
        _headLabel.layer.masksToBounds = YES;
        
        _genderImageView = [UIImageView new];
        [self.contentView addSubview:_genderImageView];
        [_genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(_headImageView);
            make.width.height.mas_equalTo(20);
        }];
        _genderImageView.layer.cornerRadius = 5;
        _genderImageView.layer.masksToBounds = YES;
        
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_right).offset(10);
            make.top.equalTo(_headImageView.mas_top);
            make.height.mas_greaterThanOrEqualTo(17);
        }];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = KBigFont;
        
        _subTitleLabel = [UILabel new];
        [self.contentView addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right).offset(10);
            make.bottom.equalTo(_titleLabel.mas_bottom);
            make.height.mas_equalTo(17);
        }];
        _subTitleLabel.textColor = [UIColor darkGrayColor];
        _subTitleLabel.font = KSmallFont;
        
        _levelImageView = [UIImageView new];
        [self.contentView addSubview:_levelImageView];
        [_levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_subTitleLabel.mas_right).offset(10);
            make.centerY.equalTo(_titleLabel);
            
        }];
        _starImageView = [UIImageView new];
        [self.contentView addSubview:_starImageView];
        [_starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_levelImageView.mas_right).offset(10);
            make.centerY.equalTo(_levelImageView);
            
        }];
        
        _phoneLabel = [UILabel new];
        [self.contentView addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_left);
            make.top.equalTo(_titleLabel.mas_bottom).offset(3);
            make.height.mas_equalTo(17);
        }];
        _phoneLabel.textColor = [UIColor darkGrayColor];
        _phoneLabel.font = KSmallFont;
        
        
        
       
        
        _addressLabel = [UILabel new];
        [self.contentView addSubview:_addressLabel];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_phoneLabel.mas_left);
            make.top.equalTo(_phoneLabel.mas_bottom).offset(3);
            make.width.mas_equalTo(KScreenWidth - 60 - 10 - 17 - 17);
            make.bottom.mas_equalTo(-10);
            make.height.mas_greaterThanOrEqualTo(17);
        }];
        _addressLabel.numberOfLines = 0;
        _addressLabel.textColor = [UIColor darkGrayColor];
        _addressLabel.font = KSmallFont;
        
        _saleLabel = [UILabel new];
        [self.contentView addSubview:_saleLabel];
        [_saleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17);
            make.bottom.equalTo(self.addressLabel);
            make.height.mas_equalTo(17);
        }];
        _saleLabel.textColor = [UIColor darkGrayColor];
        _saleLabel.font = KSmallFont;
        _saleLabel.textAlignment = NSTextAlignmentRight;
        
        _jfLabel = [UILabel new];
        [self.contentView addSubview:_jfLabel];
        [_jfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17);
            make.bottom.equalTo(self.saleLabel.mas_top).offset(-7);
            make.height.mas_equalTo(17);
        }];
        _jfLabel.textColor = [UIColor darkGrayColor];
        _jfLabel.font = KSmallFont;
        _jfLabel.textAlignment = NSTextAlignmentRight;
        _jfLabel.hidden = YES;
        
        UIImageView *statusImageView = [UIImageView new];
        [self.contentView addSubview:statusImageView];
        [statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(0);
            make.width.mas_greaterThanOrEqualTo(60);
        }];
        statusImageView.image = [UIImage imageNamed:@"all_bg"];

        _statusLabel = [UILabel new];
        [self.contentView addSubview:_statusLabel];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusImageView).offset(10);
            make.top.equalTo(statusImageView).offset(2);
            make.right.equalTo(statusImageView).offset(-10);
            make.bottom.equalTo(statusImageView).offset(-2);
        }];
        _statusLabel.numberOfLines = 0;
        _statusLabel.textColor = [UIColor darkGrayColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = KSmallFont;
        
        
    }
    return self;
}

- (void)dealloc {
    MyLog(@"销毁cell----%s", __func__);
}

@end
