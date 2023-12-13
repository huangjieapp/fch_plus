//
//  MJKTaskCommentSUbTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKTaskCommentModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKTaskCommentSUbTableViewCell : UITableViewCell
/** MJKTaskCommentModel*/
@property (nonatomic, strong) MJKTaskCommentModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
