//
//  CGCTemplateCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCTemplateCell.h"

@implementation CGCTemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCTemplateCell";
    CGCTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
