//
//  MJKTelephoneRobotDetailCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTelephoneRobotDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *arrowRightImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelLayout;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
