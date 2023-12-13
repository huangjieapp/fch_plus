//
//  MJKMaterialListType0TableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/9/16.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKMaterialListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKMaterialListTypeTableViewCell : UITableViewCell
/** <#备注#>*/
@property (nonatomic, copy) void(^shareButtonActionBlock)(void);
/** MJKMaterialListModel*/
@property (nonatomic, strong) MJKMaterialListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)heightForCellWithModel:(MJKMaterialListModel *)model;
@end

NS_ASSUME_NONNULL_END
