//
//  MJKMessageMapLabelCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/4/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKMessageMapLabelCell : UITableViewCell
/** 新增关键词按钮*/
@property (nonatomic, copy) void(^addButtonActionBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
