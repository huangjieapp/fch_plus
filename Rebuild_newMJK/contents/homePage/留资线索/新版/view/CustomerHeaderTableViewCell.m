//
//  CustomerHeaderTableViewCell.m
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import "CustomerHeaderTableViewCell.h"

@implementation CustomerHeaderTableViewCell

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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPhoto)];
        [_headImageView addGestureRecognizer:tap];
        
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
        
    }
    return self;
}

- (void)clickPhoto {
    if (self.choosePhotoBlock) {
        self.choosePhotoBlock();
    }
}

- (void)dealloc {
    MyLog(@"销毁cell----%s", __func__);
}

@end
