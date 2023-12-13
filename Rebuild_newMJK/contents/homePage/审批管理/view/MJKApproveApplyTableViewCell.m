//
//  MJKApproveApplyTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/4.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKApproveApplyTableViewCell.h"

@implementation MJKApproveApplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKApproveApplyTableViewCell";
    MJKApproveApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
