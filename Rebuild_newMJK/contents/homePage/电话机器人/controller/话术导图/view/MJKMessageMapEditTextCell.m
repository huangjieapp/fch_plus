//
//  MJKMessageMapEditTextCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/4/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKMessageMapEditTextCell.h"

@implementation MJKMessageMapEditTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKMessageMapEditTextCell";
    MJKMessageMapEditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
