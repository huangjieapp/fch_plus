//
//  MJKCommentsCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKCommentsListModel.h"

@interface MJKCommentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 模型*/
@property (nonatomic, strong) MJKCommentsListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
