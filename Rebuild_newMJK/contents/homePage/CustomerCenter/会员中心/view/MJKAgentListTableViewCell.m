//
//  MJKAgentListTableViewCell.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAgentListTableViewCell.h"

@implementation MJKAgentListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListModel:(MJKAgentListModel *)listModel {
    _listModel = listModel;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLabel.text = listModel.C_NAME;
    self.desLabel.text = listModel.I_INTEGRAL;
    self.statusLabel.text = listModel.C_STATUS_DD_NAME;
    self.customerStatusLabel.text = listModel.C_TYPE_DD_NAME;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKAgentListTableViewCell";
    MJKAgentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
@end
