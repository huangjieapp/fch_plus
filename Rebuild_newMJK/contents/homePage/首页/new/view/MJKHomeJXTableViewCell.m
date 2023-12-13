//
//  MJKHomeJXTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2022/1/14.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKHomeJXTableViewCell.h"

@implementation MJKHomeJXTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)buttonAction:(UIButton *)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(sender.tag - 10);
    }
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKHomeJXTableViewCell";
    MJKHomeJXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
