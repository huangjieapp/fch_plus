//
//  ClueFollowView.m
//  match
//
//  Created by huangjie on 2022/8/14.
//

#import "MJKCarSourceStatusView.h"

#import "DBPickerView.h"

@implementation MJKCarSourceStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [UIView new];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#55000000"];
        
        UIView *contentView = [UIView new];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(self);
            make.width.mas_lessThanOrEqualTo(KScreenWidth - 40);
        }];
        contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [UILabel new];
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.centerX.equalTo(contentView);
        }];
        
        label.text = @"提示";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.f];
        
       
        
        _chooseTextField = [UITextField new];
        [contentView addSubview:_chooseTextField];
        [_chooseTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(10);
            make.height.mas_offset(40);
            make.left.mas_offset(10);
            make.right.equalTo(contentView).offset(-10);
        }];
        _chooseTextField.borderStyle = UITextBorderStyleRoundedRect;
        _chooseTextField.font = [UIFont systemFontOfSize:14.f];
        _chooseTextField.placeholder = @"请选择锁定状态";
        UIButton *chooseButton = [UIButton new];
        [contentView addSubview:chooseButton];
        [chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.chooseTextField);
        }];
        
        
        @weakify(self);
        [[chooseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [self.chooseTextField resignFirstResponder];
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A82300_C_STATUS"];
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:nil andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                self.chooseTextField.text = title;
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
        }];
        
        
        
        _falseButton = [UIButton new];
        [contentView addSubview:_falseButton];
        [_falseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.top.equalTo(self.chooseTextField.mas_bottom).offset(10);
            make.height.mas_equalTo(45);
            make.bottom.equalTo(contentView);

        }];
        [_falseButton setBackgroundColor:kBackgroundColor];
        [_falseButton setTitle:@"取消" forState:UIControlStateNormal];
        [_falseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[_falseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self removeFromSuperview];
        }];
        
        _trueButton = [UIButton new];
        [contentView addSubview:_trueButton];
        [_trueButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.falseButton.mas_right);
            make.width.equalTo(self.falseButton.mas_width);
            make.top.equalTo(self.chooseTextField.mas_bottom).offset(10);
            make.height.mas_equalTo(45);
            make.right.equalTo(contentView);
        }];
        [_trueButton setBackgroundColor:KNaviColor];
        [_trueButton setTitle:@"确定" forState:UIControlStateNormal];
        [_trueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return self;
}

@end
