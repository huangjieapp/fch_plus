//
//  MJKWorkTomorrowTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/15.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKWorkTomorrowTableViewCell.h"

@implementation MJKWorkTomorrowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKWorkTomorrowTableViewCell";
    MJKWorkTomorrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

@end
