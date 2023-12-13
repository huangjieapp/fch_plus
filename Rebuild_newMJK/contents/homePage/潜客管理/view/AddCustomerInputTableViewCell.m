//
//  AddCustomerInputTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "AddCustomerInputTableViewCell.h"

@interface AddCustomerInputTableViewCell()<UITextViewDelegate, UITextFieldDelegate>



@end

@implementation AddCustomerInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.findCopyButton];
    self.findCopyButton.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    self.tagLabel.hidden=YES;
    [self.inputTextField addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.inputTextField addTarget:self action:@selector(textBeginEdit:) forControlEvents:UIControlEventEditingDidBegin];
	[self.inputTextField addTarget:self action:@selector(textEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
    self.inputTextField.delegate = self;
	UILabel *placeHolderLabel = [[UILabel alloc] init];
	self.textViewPlaceHolderLabel = placeHolderLabel;
	placeHolderLabel.text = @"请输入";
	placeHolderLabel.numberOfLines = 0;
	placeHolderLabel.textColor = [UIColor lightGrayColor];
	[placeHolderLabel sizeToFit];
	placeHolderLabel.textAlignment = NSTextAlignmentRight;
	[self.inputTextView addSubview:placeHolderLabel];
	self.inputTextView.delegate = self;
	// same font
	self.inputTextView.font = [UIFont systemFontOfSize:14.f];
	placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
	
	[self.inputTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
	
	
}

- (void)textViewDidChange:(UITextView *)textView {
	
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	if (self.changeTextBlock) {
		self.changeTextBlock(textView.text);
	}
}

#pragma mark  --click
- (void)textBeginEdit:(UITextField *)textField {
	if (self.textBeginEditBlock) {
		self.textBeginEditBlock();
	}
    if (self.tfBeginEditBlock) {
        self.tfBeginEditBlock(textField.text);
    }
}

- (void)textEndEdit:(UITextField *)textField {
	if (self.textEndEditBlock) {
		self.textEndEditBlock();
	}
    if (self.tfEndEditBlock) {
        self.tfEndEditBlock(textField.text);
    }
}

-(void)changeTextField:(UITextField*)textField{
     NSString*str=textField.text;
    
    if (self.textFieldLength&&str.length>self.textFieldLength) {
        NSString*subStr=[str substringToIndex:11];
        textField.text=subStr;
        
//        if (subStr&&![subStr isEqualToString:@""]) {
            if (self.changeTextBlock) {
                self.changeTextBlock(subStr);
//            }
            
        }

    }else{
        
        
//        if (str&&![str isEqualToString:@""]) {
            if (self.changeTextBlock) {
                self.changeTextBlock(str);
            }
            
//        }

        
        
        
        
    }
    
    
    
    
   
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.allNumber isEqualToString:@"是"]) {
        return [self validateNumber:string];
    } else {
        return YES;
    }
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



#pragma mark  --set
-(void)setTextStr:(NSString *)textStr{
    _textStr=textStr;
    self.inputTextField.text=textStr;
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"AddCustomerInputTableViewCell";
    AddCustomerInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

- (void)clickFindCopy:(UIButton *)sender {
    if (self.clickButtonBlock) {
        self.clickButtonBlock();
    }
}

- (UIButton *)findCopyButton {
    if (!_findCopyButton) {
        _findCopyButton.tag = 110;
        _findCopyButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-70, 7, 60, 30)];
        _findCopyButton.backgroundColor=KNaviColor;
        [_findCopyButton setTitleNormal:@"查重"];
        _findCopyButton.titleLabel.font=[UIFont systemFontOfSize:12.f];
        [_findCopyButton setTitleColor:[UIColor blackColor]];
        [_findCopyButton addTarget:self action:@selector(clickFindCopy:)];
        _findCopyButton.layer.cornerRadius = 3.f;
        _findCopyButton.layer.masksToBounds = YES;
    }
    return _findCopyButton;
}

@end
