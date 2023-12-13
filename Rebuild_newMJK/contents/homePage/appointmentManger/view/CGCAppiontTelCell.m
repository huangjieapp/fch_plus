//
//  CGCAppiontTelCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCAppiontTelCell.h"

@implementation CGCAppiontTelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
        static NSString *ID = @"CGCAppiontTelCell";
        CGCAppiontTelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
            
           
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
        }
        return cell;
        
}
    

    
    
@end
