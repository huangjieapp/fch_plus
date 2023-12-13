//
//  MJKCommunityScreenCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJKShowAreaModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKCommunityScreenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** MJKShowAreaModel*/
@property (nonatomic, strong) MJKShowAreaModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
