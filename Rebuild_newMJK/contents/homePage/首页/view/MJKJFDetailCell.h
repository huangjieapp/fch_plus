//
//  MJKJFDetailCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKJFDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKJFDetailCell : UITableViewCell
/** MJKJFDetailModel*/
@property (nonatomic, strong) MJKJFDetailModel *jfDetailModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
