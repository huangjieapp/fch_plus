//
//  MJKPKAddOrEditTableViewCell.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKPKAddOrEditTableViewCell.h"

@interface MJKPKAddOrEditTableViewCell ()

@end

@implementation MJKPKAddOrEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.groupImageView.layer.borderWidth = 2.f;
//    self.groupImageView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.contentTextField addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
}

- (void)changeText:(UITextField *)textField {
    if (self.backTextFieldTextBlock) {
        self.backTextFieldTextBlock(textField.text);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKPKAddOrEditTableViewCell";
    MJKPKAddOrEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
