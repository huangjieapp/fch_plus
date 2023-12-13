//
//  MJKRecheckTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/5.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKRecheckTableViewCell.h"

@implementation MJKRecheckTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)switchButtonAction:(UISwitch *)sender {
    if (self.switchButtonActionBlock) {
        self.switchButtonActionBlock();
    }
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKRecheckTableViewCell";
    MJKRecheckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
