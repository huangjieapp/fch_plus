//
//  MJKPushOpenFollowSetCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/18.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKCustomReturnSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKPushOpenFollowSetCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)updateCellWithModel:(MJKCustomReturnSubModel *)model andRow:(NSInteger)row andTypeNumber:(NSString *)typeNumber;
@end

NS_ASSUME_NONNULL_END
