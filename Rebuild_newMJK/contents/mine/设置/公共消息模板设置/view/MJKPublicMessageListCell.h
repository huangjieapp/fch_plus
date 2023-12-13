//
//  MJKPublicMessageListCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/14.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCTalkModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKPublicMessageListCell : UITableViewCell
/** CGCTalkModel*/
@property (nonatomic, strong) CGCTalkModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight:(CGCTalkModel *)model;
@end

NS_ASSUME_NONNULL_END
