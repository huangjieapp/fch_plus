//
//  MJKMessageCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKMessageCenterModel;

@interface MJKMessageCell : UITableViewCell
/** 清楚badge*/
@property (nonatomic, assign) BOOL cleanBadge;
/** 全选*/
@property (nonatomic, assign) BOOL isAllChoose;
/** 已读*/
@property (nonatomic, assign) BOOL isRead;
/** MJKMessageCenterModel*/
@property (nonatomic, strong) MJKMessageCenterModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
