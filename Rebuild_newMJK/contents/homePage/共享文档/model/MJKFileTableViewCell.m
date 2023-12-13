//
//  MJKFileTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/7.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKFileTableViewCell.h"

@implementation MJKFileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKFileTableViewCell";
    MJKFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
@end
