//
//  MJKFlowProcessCustomerInfoCell.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/12/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKFlowProcessCustomerInfoCell.h"

@interface MJKFlowProcessCustomerInfoCell ()

@end


@implementation MJKFlowProcessCustomerInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentTF addTarget:self action:@selector(beginEdit:) forControlEvents:UIControlEventEditingDidBegin];
    [self.contentTF addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)beginEdit:(UITextField *)sender {
    if (self.textBeginEditBlock) {
        self.textBeginEditBlock();
    }
}

- (void)endEdit:(UITextField *)sender {
    if (self.textEndEditBlock) {
        self.textEndEditBlock();
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKFlowProcessCustomerInfoCell";
    MJKFlowProcessCustomerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
