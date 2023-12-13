//
//  MJKCustomerLabelCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/15.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKCustomerTheLabelModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKCustomerLabelCell : UITableViewCell
/** MJKCustomerLabelModel*/
@property (nonatomic, strong) MJKCustomerTheLabelModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)heightForCell:(MJKCustomerTheLabelModel *)model;
/** delete data*/
@property (nonatomic, copy) void(^deleteCustomerLabelBlock)(void);
/** delete the label*/
@property (nonatomic, copy) void(^deleteTheLabelBlock)(NSString *C_ID);
/** add label*/
@property (nonatomic, copy) void(^addLabelBlock)(UIButton *button);
@end

NS_ASSUME_NONNULL_END
