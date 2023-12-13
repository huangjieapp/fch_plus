//
//  OrderNumberSetTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "OrderNumberSetTableViewCell.h"

@implementation OrderNumberSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
//    self.TextFie.enabled=NO;
    [self.TextFie addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)changeTextField:(UITextField*)textField{
    if (self.changeTextFieBlock) {
        self.changeTextFieBlock(textField.text);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

@end
