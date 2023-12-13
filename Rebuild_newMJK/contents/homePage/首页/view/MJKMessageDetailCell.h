//
//  MJKMessageDetailCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/22.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKMessageDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKMessageDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
/** 清楚badge*/
@property (nonatomic, assign) BOOL cleanBadge;
/** 全选*/
@property (nonatomic, assign) BOOL isAllChoose;
/** 已读*/
@property (nonatomic, assign) BOOL isDelete;
/** MJKMessageDetailModel*/
@property (nonatomic, strong) MJKMessageDetailModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
