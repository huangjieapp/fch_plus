//
//  MJKAgentChangeStatusTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/3/4.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKAgentChangeStatusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
