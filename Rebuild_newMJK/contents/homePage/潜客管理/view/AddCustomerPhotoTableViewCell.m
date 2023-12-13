//
//  AddCustomerPhotoTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "AddCustomerPhotoTableViewCell.h"


@interface AddCustomerPhotoTableViewCell()<UITextFieldDelegate>


@end

@implementation AddCustomerPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageButton.layer.cornerRadius=6;
    self.imageButton.layer.masksToBounds=YES;
    
    self.nameTextField.delegate=self;
    [self.nameTextField addTarget:self action:@selector(changeNameTextfield:) forControlEvents:UIControlEventEditingChanged];
    
}


#pragma mark  -- click
- (IBAction)clickPhotoImageButton:(id)sender {
    if (self.clickPortraitBlock) {
        self.clickPortraitBlock();
    }
    
}


-(void)changeNameTextfield:(UITextField*)textField{
    if (self.changeTextFieldBlock) {
        self.changeTextFieldBlock(textField.text);
    }
    
}




#pragma mark  --set
-(void)setPortraitStr:(NSString *)portraitStr{
    _portraitStr=portraitStr;
    [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:portraitStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
}

-(void)setNameStr:(NSString *)nameStr{
    _nameStr=nameStr;
    self.nameTextField.text=nameStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"AddCustomerPhotoTableViewCell";
    AddCustomerPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
