//
//  MJKExpandNewAddTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/4/13.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKExpandNewAddTableViewCell.h"

@implementation MJKExpandNewAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)buttonAcrion:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected == YES) {
        [sender setBackgroundColor:KNaviColor];
    } else {
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
    if (self.buttonAcrionBlock) {
        self.buttonAcrionBlock(sender.titleLabel.text, sender.isSelected);
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKExpandNewAddTableViewCell";
    MJKExpandNewAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
