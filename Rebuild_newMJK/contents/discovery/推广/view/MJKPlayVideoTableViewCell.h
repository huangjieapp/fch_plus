//
//  MJKPlayVideoTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/18.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCExpandModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKPlayVideoTableViewCell : UITableViewCell
/** CGCExpandModel*/
@property (nonatomic, strong) CGCExpandModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
