//
//  MJKPKSetTableViewCell.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKPKSetTableViewCell.h"

@implementation MJKPKSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 15.f;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKPKSetTableViewCell";
    MJKPKSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
