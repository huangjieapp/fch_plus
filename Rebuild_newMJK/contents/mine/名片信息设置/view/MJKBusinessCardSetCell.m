//
//  MJKBusinessCardSetCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/27.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKBusinessCardSetCell.h"

@implementation MJKBusinessCardSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)textChangeAction:(UITextField *)sender {
    if (self.textChangeBlock) {
        self.textChangeBlock(sender.text);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKBusinessCardSetCell";
    MJKBusinessCardSetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
