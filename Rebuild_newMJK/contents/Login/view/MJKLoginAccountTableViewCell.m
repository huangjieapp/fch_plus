//
//  MJKLoginAccountTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/9.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKLoginAccountTableViewCell.h"

@implementation MJKLoginAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteButtonAction:(UIButton *)sender {
    if (self.deleteAccountActionBlock) {
        self.deleteAccountActionBlock();
    }
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKLoginAccountTableViewCell";
    MJKLoginAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
