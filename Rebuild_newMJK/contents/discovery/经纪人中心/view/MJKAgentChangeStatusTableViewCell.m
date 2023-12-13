//
//  MJKAgentChangeStatusTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/3/4.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKAgentChangeStatusTableViewCell.h"

@implementation MJKAgentChangeStatusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKAgentChangeStatusTableViewCell";
    MJKAgentChangeStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    return cell;
    
}

@end
