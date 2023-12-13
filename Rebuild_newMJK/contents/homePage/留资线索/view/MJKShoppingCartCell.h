//
//  MJKShoppingCartCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/4/2.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKProductShowModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKShoppingCartCell : UITableViewCell
/** MJKProductShowModel*/
@property (nonatomic, strong) MJKProductShowModel *model;
/** 添加/减少商品*/
@property (nonatomic, copy) void(^addOrSubProductActionBlock)(NSString *typeStr);
@property (nonatomic, copy) void(^priceChangeBlock)(void);
@property (nonatomic, copy) void(^updateBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
