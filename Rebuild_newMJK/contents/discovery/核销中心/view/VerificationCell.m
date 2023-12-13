//
//  VerificationCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "VerificationCell.h"

@implementation VerificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"VerificationCell";
    VerificationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

@end
