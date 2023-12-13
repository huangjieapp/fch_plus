//
//  CGCOrderDetailNormalCell.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CGCOrderDetailNormalCell.h"

@interface CGCOrderDetailNormalCell ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation CGCOrderDetailNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	UILabel *placeHolderLabel = [[UILabel alloc] init];
//	self.textViewPlaceHolderLabel = placeHolderLabel;
	placeHolderLabel.text = @"请输入";
	placeHolderLabel.numberOfLines = 0;
	placeHolderLabel.textColor = [UIColor lightGrayColor];
	[placeHolderLabel sizeToFit];
	placeHolderLabel.textAlignment = NSTextAlignmentRight;
	[self.textView addSubview:placeHolderLabel];
	self.textView.delegate = self;
	// same font
	self.textView.font = [UIFont systemFontOfSize:14.f];
	placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
	
	[self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}

- (void)updateRow1Address {
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(becomeMy)];
    [self.contentLabel addGestureRecognizer:tap];
    self.contentLabel.userInteractionEnabled = YES;
    [self.textfield addTarget:self action:@selector(changeLabel:) forControlEvents:UIControlEventEditingChanged];
    [self.textfield addTarget:self action:@selector(endLabel:) forControlEvents:UIControlEventEditingDidEnd];
    self.textfield.hidden = YES;
    self.contentLabel.hidden = NO;
}


- (void)becomeMy {
    self.textfield.hidden=NO;
    self.contentLabel.hidden=YES;
    [self.textfield becomeFirstResponder];
}

-(void)endLabel:(UITextField *)textField
{
    
    if (textField==self.textfield) {
        self.contentLabel.hidden=NO;
        self.textfield.hidden=YES;
        [self.textfield resignFirstResponder];
    }
}

-(void)changeLabel:(UITextField *)text
{
    self.contentLabel.hidden=YES;
    self.contentLabel.text=text.text;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withType:(CGCOrderDetailNormalCellStyle )type{
    static NSString *ID = @"CGCOrderDetailNormalCell";
    CGCOrderDetailNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (type == CGCOrderDetailNormalCellDisplay) {
         
            cell.textView.userInteractionEnabled=NO;
         cell.textfield.userInteractionEnabled=NO;
            cell.textView.hidden=YES;
           
        }else if(type == CGCOrderDetailNormalCellEidt){
            
            cell.textfield.userInteractionEnabled=YES;
              cell.textView.hidden=YES;
        }
        
    }
    return cell;
    
}
@end
