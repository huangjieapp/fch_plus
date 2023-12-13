//
//  MJKAdditionalTrackTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/2.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKAdditionalTrackModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKAdditionalTrackTableViewCell : UITableViewCell
/** <#注释#>*/
@property (nonatomic, strong) MJKAdditionalTrackModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
