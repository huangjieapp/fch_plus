//
//  CustomerInputTableViewCell.m
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import "CustomerInputTableViewCell.h"

@interface CustomerInputTableViewCell ()<UITextFieldDelegate>

@end

@implementation CustomerInputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.centerY.equalTo(self.contentView);
//            make.width.mas_greaterThanOrEqualTo(80);
        }];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.textColor = [UIColor blackColor];
        
        _mustLabel = [UILabel new];
        [self.contentView addSubview:_mustLabel];
        [_mustLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right);
            make.top.equalTo(self.titleLabel);
        }];
        _mustLabel.text = @"*";
        _mustLabel.textColor = [UIColor redColor];
        _mustLabel.hidden = YES;
        
        
        
        _checkButton = [UIButton new];
        [self.contentView addSubview:_checkButton];
        [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.centerY.equalTo(self.contentView);
//            make.size.mas_equalTo(CGSizeMake(50, 30));
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [_checkButton setBackgroundColor:KNaviColor];
        [_checkButton setTitle:@"查重" forState:UIControlStateNormal];
        [_checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _checkButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _checkButton.layer.cornerRadius = 5.f;
        _checkButton.layer.masksToBounds = YES;
        _checkButton.hidden = YES;
        
        _inputTextField = [UITextField new];
        [self.contentView addSubview:_inputTextField];
        [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(17);
            make.right.equalTo(self.checkButton.mas_left).offset(-10);
            make.top.mas_equalTo(12);
            make.bottom.mas_equalTo(-12);
        }];
        _inputTextField.placeholder = @"请输入";
        _inputTextField.textColor = [UIColor darkGrayColor];
        _inputTextField.font = [UIFont systemFontOfSize:14.f];
        _inputTextField.textAlignment = NSTextAlignmentRight;
        _inputTextField.delegate = self;
        
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.allNumber isEqualToString:@"是"]) {
        return [self validateNumber:string];
    }
    if (self.isPhoneNumber) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (self.number <= textField.text.length) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateNumber:(NSString *)number {
    BOOL res = YES;
    NSCharacterSet *tempSet = [NSCharacterSet  characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString *string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tempSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (void)dealloc {
    MyLog(@"销毁cell----%s", __func__);
}

@end
