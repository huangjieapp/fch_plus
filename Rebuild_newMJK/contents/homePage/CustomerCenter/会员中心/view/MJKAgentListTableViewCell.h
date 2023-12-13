//
//  MJKAgentListTableViewCell.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJKAgentListModel.h"

@interface MJKAgentListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
/** 列表模型*/
@property(nonatomic,strong) MJKAgentListModel *listModel;
@property (weak, nonatomic) IBOutlet UILabel *customerStatusLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
