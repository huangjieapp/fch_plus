//
//  MJKSocialPresonShareTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/3/3.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKSocialPresonShareModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKSocialPresonShareTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewWidthLayout;
@property (weak, nonatomic) IBOutlet UIView *detailView;
/** <#注释#>*/
@property (nonatomic, strong) MJKSocialPresonShareModel *model;
+ (CGFloat)cellForHeight:(MJKSocialPresonShareModel *)model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
