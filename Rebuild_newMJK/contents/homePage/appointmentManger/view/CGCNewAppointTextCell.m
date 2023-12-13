//
//  CGCNewAppointTextCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/30.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCNewAppointTextCell.h"

@interface CGCNewAppointTextCell()<UITextViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation CGCNewAppointTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.remarkLab.backgroundColor=[UIColor whiteColor];
//    self.remarkLab.layer.borderWidth=1;
//    self.remarkLab.layer.borderColor=[UIColor blackColor].CGColor;
//    self.remarkLab.layer.cornerRadius=2;
//    self.remarkLab.layer.masksToBounds=YES;
    
    self.textView.layer.borderColor=DBColor(193, 193, 193).CGColor;
    self.textView.layer.borderWidth=0.5;
    self.textView.layer.cornerRadius=4;
    self.textView.layer.masksToBounds=YES;
    
//    [self.textView addTarget:self action:@selector(clickRemarkTV:) forControlEvents:UIControlEventValueChanged];
//     [self.textView addTarget:self action:@selector(endclickRemarkTV:) forControlEvents:UIControlEventEditingDidEnd];
   
    self.textView.delegate=self;
    [self voiceRecord];
    
    
    self.placeholderLabel = [UILabel new];
    self.placeholderLabel.text = @"请输入";
    self.placeholderLabel.font = [UIFont systemFontOfSize:14.f];
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    self.placeholderLabel.numberOfLines = 0;
    [self.textView addSubview:self.placeholderLabel];
    [self.textView setValue:self.placeholderLabel forKey:@"_placeholderLabel"];
    
	
}

- (void)setPlaceholderStr:(NSString *)placeholderStr {
    _placeholderStr = placeholderStr;
    self.placeholderLabel.text = placeholderStr;
}

- (void)voiceRecord {
	UIButton *voiceButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 40, CGRectGetMaxY(self.textView.frame) - 30, 25, 25)];
	voiceButton.hidden = YES;
	[voiceButton setBackgroundImage:[UIImage imageNamed:@"语音搜索大按钮"] forState:UIControlStateNormal];
//	imageView.image = [UIImage imageNamed:@"语音搜索大按钮"];
	[self.contentView addSubview:voiceButton];
	self.voiceButton = voiceButton;
	
}



//- (void)buttonAction:(UIButton *)sender {
//	sender.state
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCNewAppointTextCell";
    CGCNewAppointTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}


#pragma mark  --click
//-(void)clickRemarkTV:(UITextField*)textField{
//    NSString*textStr=textField.text;
//    self.remarkLab.text=textField.text;
//    if (self.changeTextBlock) {
//        self.changeTextBlock(textStr);
//    }
//    
//}
//-(void)endclickRemarkTV:(UITextField*)textField{
//    if (self.endBlock) {
//        self.endBlock();
//    }
//    
//}


-(void)textViewDidChange:(UITextView *)textView{
     NSString*textStr=textView.text;
    if (self.changeTextBlock) {
        self.changeTextBlock(textStr);
    }

}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.startInputBlock) {
        self.startInputBlock();
    }
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (self.endBlock) {
        self.endBlock();
    }

}


#pragma mark  --set
-(void)setBeforeText:(NSString *)beforeText{
    _beforeText=beforeText;
    self.textView.text=beforeText;
    
}


@end
