//
//  MJKScoialMarketTeamTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKSocialMarketHeaderModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKScoialMarketTeamTableViewCell : UITableViewCell
/** name array*/
@property (nonatomic, strong) NSArray *nameArray;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** <#注释#>*/
@property (nonatomic, strong) MJKSocialMarketHeaderModel *model;
@end

NS_ASSUME_NONNULL_END
