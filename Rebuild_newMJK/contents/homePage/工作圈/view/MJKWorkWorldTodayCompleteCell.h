//
//  MJKWorkWorldTodayCompleteCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/26.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKWorkWorldObjectMapContentModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKWorkWorldTodayCompleteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *planCompLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
/** MJKWorkWorldObjectMapContentModel*/
@property (nonatomic, strong) MJKWorkWorldObjectMapContentModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
