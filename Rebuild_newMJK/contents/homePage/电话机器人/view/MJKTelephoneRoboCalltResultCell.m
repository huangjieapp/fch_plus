//
//  MJKTelephoneRoboCalltResultCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/6.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTelephoneRoboCalltResultCell.h"

@implementation MJKTelephoneRoboCalltResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKTelephoneRoboCalltResultCell";
    MJKTelephoneRoboCalltResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
