//
//  PersonInfoTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/10.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "PersonInfoTableViewCell.h"

@interface PersonInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *BGView;


@end

@implementation PersonInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.BGView.backgroundColor=[UIColor whiteColor];
    self.BGView.layer.cornerRadius=5;
    self.BGView.layer.masksToBounds=YES;
    
    
   
    [self.myTextField addTarget:self action:@selector(changeTextF:) forControlEvents:UIControlEventEditingChanged];
    
}



#pragma mark  --click
-(void)changeTextF:(UITextField*)textField{
    if (self.type==textFieldTypePhone) {
        if (textField.text.length>=11) {
            NSString*str=[textField.text substringToIndex:11];
            textField.text=str;
        }
        
    }
    
    
    if (self.changeTextFieldBlock) {
        self.changeTextFieldBlock(textField.text, self.indexRow);
    }
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    // Configure the view for the selected state
}



#pragma mark  --set
-(void)setType:(textFieldType)type{
    _type=type;
    if (type==textFieldTypePhone) {
        
        self.myTextField.keyboardType=UIKeyboardTypePhonePad;
    }else if (type==textFieldTypeEmail){
        self.myTextField.keyboardType=UIKeyboardTypeEmailAddress;
    }
    
    
    else{
        self.myTextField.keyboardType=UIKeyboardTypeDefault;
    }

    
    
}


@end
