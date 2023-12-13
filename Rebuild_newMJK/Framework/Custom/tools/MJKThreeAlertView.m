//
//  MJKThreeAlertView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/4/17.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKThreeAlertView.h"

@interface MJKThreeAlertView ()<UIPickerViewDelegate, UIPickerViewDataSource>
/** 位置*/
@property (nonatomic, strong) NSString *postionStr;
/** number*/
@property (nonatomic, strong) NSString *numberStr;
/** 位置信息*/
@property (nonatomic, strong) NSString *postionInfoStr;
@end

@implementation MJKThreeAlertView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)titleStr withText:(NSString *)text withTFTextArray:(NSArray *)titleArray withPlaceholder:(NSArray *)placeholderArray withButtonArray:(NSArray *)buttonArray {
    if (self = [super initWithFrame:frame]) {
        if (titleArray.count > 0) {
            if (![self.vcName isEqualToString:@"在线展厅"]) {
                self.numberStr = titleArray[0];
                self.postionInfoStr = titleArray[1];
                self.postionStr = titleArray[2];
            }
        }
        [self configWithFrame:frame withTitle:titleStr withText:text withTFTextArray:titleArray withPlaceholder:placeholderArray withButtonArray:buttonArray];
    }
    return self;
}

- (void)configWithFrame:(CGRect)frame withTitle:(NSString *)titleStr withText:(NSString *)text withTFTextArray:(NSArray *)titleArray withPlaceholder:(NSArray *)placeholderArray withButtonArray:(NSArray *)buttonArray {
    //背景
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = .5f;
    [self addSubview:bgView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBG)];
    [bgView addGestureRecognizer:tapGR];
    
    //弹框
    CGFloat alertHeight = 0;
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(10, (KScreenHeight - alertHeight) / 2, KScreenWidth - 20, alertHeight)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 5.f;
    alertView.layer.masksToBounds = YES;
    [self addSubview:alertView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.text = titleStr;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    [alertView addSubview:titleLabel];
    if (titleStr.length > 0) {
        titleLabel.frame = CGRectMake(0, 0, alertView.frame.size.width, 20);
        alertHeight += titleLabel.frame.size.height;
    }
    
    //提示语
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    textLabel.font = [UIFont systemFontOfSize:12.f];
    textLabel.text = text;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor blackColor];
    [alertView addSubview:textLabel];
    if (text.length > 0) {
        textLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), alertView.frame.size.width, 20);
        alertHeight += textLabel.frame.size.height;
    }
    
//    if (titleArray.count > 0) {
//        for (int i = 0; i < titleArray.count; i++) {
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, (CGRectGetMaxY(textLabel.frame) + 5) + (i * 40), 100, 30)];
//            label.font = [UIFont systemFontOfSize:14.f];
//            label.text = titleArray[i];
//            label.textAlignment = NSTextAlignmentLeft;
//            label.textColor = [UIColor blackColor];
//            [alertView addSubview:label];
//
//            UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 5, CGRectGetMinY(label.frame), alertView.frame.size.width - 110, 30)];
//            tf.placeholder = placeholderArray[i];
//            tf.font = [UIFont systemFontOfSize:14.f];
//            tf.borderStyle = UITextBorderStyleRoundedRect;
//            tf.tag = 100 + i;
//            [alertView addSubview:tf];
//
//            if ([placeholderArray[i] hasPrefix:@"请输入"]) {
//                tf.inputView = [self pickView];
//            } else {
//                [tf addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
//            }
//
//            if (i == titleArray.count  - 1) {
//
//                alertHeight += (tf.frame.size.height + 10);
//            }
//        }
//    } else {
        for (int i = 0; i < placeholderArray.count; i++) {
            UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(10, (CGRectGetMaxY(textLabel.frame) + 5) + (i * 40), alertView.frame.size.width - 20, 30)];
            tf.placeholder = placeholderArray[i];
            tf.font = [UIFont systemFontOfSize:14.f];
            tf.borderStyle = UITextBorderStyleRoundedRect;
            tf.tag = 100 + i;
            [alertView addSubview:tf];
            
            if ([placeholderArray[i] hasPrefix:@"请选择"]) {
                tf.inputView = [self pickView];
            } else {
                
                [tf addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
            }
            if (titleArray.count > 0) {
                tf.text = titleArray[i];
            }
//            if (i == placeholderArray.count  - 1) {
            
                alertHeight += (tf.frame.size.height + 10);
//            }
        }
//    }
    
    
    if (buttonArray.count > 0) {
        for (int i = 0; i < buttonArray.count; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (alertView.frame.size.width / 2), alertHeight + 10, alertView.frame.size.width / 2, 40)];
            if (i == buttonArray.count - 1) {
                [button setBackgroundColor:KNaviColor];
            } else {
                [button setBackgroundColor:kBackgroundColor];
            }
            [button setTitleNormal:buttonArray[i]];
            [button setTitleColor:[UIColor blackColor]];
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [alertView addSubview:button];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        alertHeight += 50;
    }
    
    
    
    
    CGRect alertFrame = alertView.frame;
    alertFrame.size.height = alertHeight ;
    alertFrame.origin.y = (KScreenHeight - alertFrame.size.height) / 2;
    alertView.frame = alertFrame;
    
    
    
}

- (void)buttonAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        [self closeBG];
        return;
    }
    if (self.numberStr.length <= 0) {
        [JRToast showWithText:@"请输入设备号"];
        return;
    }
    if (self.postionInfoStr.length <= 0) {
        [JRToast showWithText:@"请输入位置信息"];
        return;
    }
    if (![self.vcName isEqualToString:@"在线展厅"]) {
        if (self.postionStr.length <= 0) {
            [JRToast showWithText:@"请选择位置"];
            return;
        }
    }
    
    if (self.buttonActionBlock) {
        self.buttonActionBlock(sender.titleLabel.text, self.numberStr, self.postionInfoStr, self.postionStr);
    }
//    [self closeBG];
}

- (void)changeText:(UITextField *)tf {
    if (tf.tag - 100 == 0) {
        self.numberStr = tf.text;
    } else if (tf.tag - 100 == 1) {
        self.postionInfoStr = tf.text;
    }
}

- (UIView *)pickView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    [view addSubview:pickView];
    pickView.delegate = self;
    return view;
}

//- (void)setDataArray:(NSArray *)dataArray {
//    _dataArray = dataArray;
//    self.postionStr = dataArray[0];
//    for (UIView *subView in [self.subviews[1] subviews]) {
//        if ([subView isKindOfClass:[UITextField class]]) {
//            UITextField *tf = (UITextField *)subView;
//            if ([tf.placeholder hasPrefix:@"请选择"]) {
//                tf.text = self.postionStr;
//            }
//        }
//    }
//}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (![self.dataArray[row] isEqualToString:@"请选择"]) {
        self.postionStr = self.dataArray[row];
        for (UIView *subView in [self.subviews[1] subviews]) {
            if ([subView isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField *)subView;
                if ([tf.placeholder hasPrefix:@"请选择"]) {
                    tf.text = self.postionStr;
                }
            }
        }
    } else {
        self.postionStr = @"";
        for (UIView *subView in [self.subviews[1] subviews]) {
            if ([subView isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField *)subView;
                if ([tf.placeholder hasPrefix:@"请选择"]) {
                    tf.text = @"";
                }
            }
        }
    }
    
}



//MARK:-关闭页面
- (void)closeBG {
    [self removeFromSuperview];
}

@end
