//
//  MJKApproveApplyTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/4.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKApproveApplyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLabelLeftLayout;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
