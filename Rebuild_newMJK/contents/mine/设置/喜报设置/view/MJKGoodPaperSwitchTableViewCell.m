//
//  MJKGoodPaperSwitchTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/23.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKGoodPaperSwitchTableViewCell.h"

@implementation MJKGoodPaperSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)openSwitchAction:(UISwitch *)sender {
    if (self.openSwitchBlock) {
        self.openSwitchBlock(sender.isOn);
    }
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKGoodPaperSwitchTableViewCell";
    MJKGoodPaperSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
