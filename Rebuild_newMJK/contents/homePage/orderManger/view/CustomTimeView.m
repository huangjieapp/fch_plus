//
//  CustomTimeView.m
//  match5.0
//
//  Created by huangjie on 2023/1/2.
//

#import "CustomTimeView.h"

@implementation CustomTimeView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#55000000"];
        UIView *cview = [UIView new];
        [self addSubview:cview];
        [cview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
        cview.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
        
        UILabel *titleLabel = [UILabel new];
        [cview addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.centerX.equalTo(cview);
        }];
        titleLabel.textColor = [UIColor colorWithHex:@"#000000"];
        titleLabel.text = @"自定义时间";
        
        UILabel *topLeftLabel = [UILabel new];
        [cview addSubview:topLeftLabel];
        [topLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(10);
            make.width.mas_lessThanOrEqualTo(60);
        }];
        topLeftLabel.text = @"开始时间";
        topLeftLabel.textColor = [UIColor colorWithHex:@"#000000"];
        topLeftLabel.font = KNomarlFont;
        
        UITextField *topRightTextField = [UITextField new];
        [cview addSubview:topRightTextField];
        [topRightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topLeftLabel.mas_right).offset(10);
            make.centerY.equalTo(topLeftLabel);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(30);
        }];
        topRightTextField.borderStyle = UITextBorderStyleRoundedRect;
        topRightTextField.placeholder = @"请选择";
        topRightTextField.backgroundColor = kBackgroundColor;
        topRightTextField.font = KNomarlFont;
        topRightTextField.enabled = NO;
        UIButton *beginTimeButton = [UIButton new];
        [cview addSubview:beginTimeButton];
        [beginTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(topRightTextField);
        }];
        
        UILabel *bottomLeftLabel = [UILabel new];
        [cview addSubview:bottomLeftLabel];
        [bottomLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLeftLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(10);
            make.width.mas_lessThanOrEqualTo(60);
        }];
        bottomLeftLabel.text = @"结束时间";
        bottomLeftLabel.textColor = [UIColor colorWithHex:@"#000000"];
        bottomLeftLabel.font = KNomarlFont;

        UITextField *bottomRightTextField = [UITextField new];
        [cview addSubview:bottomRightTextField];
        [bottomRightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomLeftLabel.mas_right).offset(10);
            make.centerY.equalTo(bottomLeftLabel);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(30);
        }];
        bottomRightTextField.borderStyle = UITextBorderStyleRoundedRect;
        bottomRightTextField.placeholder = @"请选择";
        bottomRightTextField.backgroundColor = kBackgroundColor;
        bottomRightTextField.font = KNomarlFont;
        bottomRightTextField.enabled = NO;
        UIButton *endTimeButton = [UIButton new];
        [cview addSubview:endTimeButton];
        [endTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(bottomRightTextField);
        }];
        
        UIView *bottomView = [UIView new];
        [cview addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomRightTextField.mas_bottom).offset(30);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(45);
            make.bottom.mas_equalTo(0);
        }];
        UIButton *leftButton = [UIButton new];
        [bottomView addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
        }];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor colorWithHex:@"#000000"] forState:UIControlStateNormal];
        leftButton.titleLabel.font = KNomarlFont;
        
        UIButton *rightButton = [UIButton new];
        [bottomView addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.left.equalTo(leftButton.mas_right);
            make.width.mas_equalTo(leftButton.mas_width);
        }];
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
        rightButton.titleLabel.font = KNomarlFont;
        rightButton.backgroundColor = KNaviColor;
        
        @weakify(self);
        [[beginTimeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            MyLog(@"开始时间");
            [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYMD title:topRightTextField.text selectValue:topRightTextField.text resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                topRightTextField.text = selectValue;
            }];
        }];
        [[endTimeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            MyLog(@"结束时间");
            [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYMD title:bottomRightTextField.text selectValue:bottomRightTextField.text resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                bottomRightTextField.text = selectValue;
            }];
        }];
        [[leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self removeFromSuperview];
        }];
        
        [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (topRightTextField.text.length <= 0) {
                [JRToast showWithText:@"请选择开始时间"];
                return;
            }
            
            if (bottomRightTextField.text.length <= 0) {
                [JRToast showWithText:@"请选择结束时间"];
                return;
            }
            if (self.chooseTimeBlock) {
                self.chooseTimeBlock(topRightTextField.text, bottomRightTextField.text);
            }
            [self removeFromSuperview];
        }];
        
    }
    return self;
}

@end
