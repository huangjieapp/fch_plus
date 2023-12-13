//
//  MJKTextRemarkView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTextRemarkView.h"
#import "DBPickerView.h"

@interface MJKTextRemarkView ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, strong) NSString *timeStr;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
@property (nonatomic, strong) NSString *inputTextStr;


@end

@implementation MJKTextRemarkView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTextView.delegate = self;
    
    self.timeTF.inputView = [[UIView alloc]init];
    self.timeStr = [DBTools getTimeFomatFromTimeStampAddDay:1];
    self.timeTF.text = self.timeStr;
    
    // _placeholderLabel
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    
    placeHolderLabel.text = @"请输入本次联系内容";
    
    placeHolderLabel.numberOfLines = 0;
    
    placeHolderLabel.textColor = [UIColor colorWithRed:208 / 255.0 green:208 / 255.0 blue:208 / 255.0 alpha:1.0];
    
    placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
    
    [placeHolderLabel sizeToFit];
    
    [_contentTextView addSubview:placeHolderLabel];
    
    [_contentTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}

- (void)setInputStr:(NSString *)inputStr {
    _inputStr = inputStr;
    self.inputTextStr = inputStr;
    self.contentTextView.text = inputStr;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    self.inputTextStr = textView.text;
    if (self.changeTextViewBlock) {
        self.changeTextViewBlock(textView.text);
    }
}
- (IBAction)buttonAction:(UIButton *)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(sender.titleLabel.text, self.inputTextStr, self.timeStr);
    }
    [self removeFromSuperview];
}

- (void)setFrame:(CGRect)frame {
    frame.size.width = KScreenWidth;
    frame.size.height = KScreenHeight;
    [super setFrame:frame];
}

- (IBAction)timeSelectTF:(UITextField *)sender {
    [self selectTime:sender];
}


- (void)selectTime:(UITextField *)tf {
    DBSelf(weakSelf);
    DBPickerView *pickerView = [[DBPickerView alloc]initWithFrame:self.frame andCurrentType:PickViewTypeDate andmtArrayDatas:nil andSelectStr:tf.text andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
       tf.text = title;
        weakSelf.timeStr = title;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
    pickerView.cancelBlock = ^{
        [weakSelf.timeTF resignFirstResponder];
    };
}

@end
