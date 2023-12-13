//
//  MJKLoginAccountTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/9.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKLoginAccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
/** 删除*/
@property (nonatomic, copy) void(^deleteAccountActionBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
