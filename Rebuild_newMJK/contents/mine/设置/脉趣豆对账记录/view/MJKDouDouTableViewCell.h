//
//  MJKDouDouTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKRedPackageModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKDouDouTableViewCell : UITableViewCell
/** MJKRedPackageModel*/
@property (nonatomic, strong) MJKRedPackageModel *model;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *doudouLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiangLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
