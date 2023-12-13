//
//  MJKProductShowTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/25.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKProductShowModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKProductShowTableViewCell : UITableViewCell
/** MJKProductShowModel*/
@property (nonatomic, strong) MJKProductShowModel *model;
@property (nonatomic, strong) NSArray *productArray;
/** typeArray*/
@property (nonatomic, strong) NSArray *typeArray;
/** 添加/减少商品*/
@property (nonatomic, copy) void(^addOrSubProductActionBlock)(NSString *typeStr);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
