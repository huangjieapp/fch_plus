//
//  MJKFunnelMoreFieldTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/8.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKFunnelMoreFieldTableViewCell.h"

@implementation MJKFunnelMoreFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)textChange:(UITextField *)sender {
    if (self.textChangeBlock) {
        self.textChangeBlock(sender.text);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKFunnelMoreFieldTableViewCell";
    MJKFunnelMoreFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
