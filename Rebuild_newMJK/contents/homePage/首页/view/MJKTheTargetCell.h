//
//  MJKTheTargetCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJKHomePageJXModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKTheTargetCell : UITableViewCell
/** <#注释#>*/
@property (nonatomic, strong) NSString *titleStr;
- (void)reloadCellWithModel:(MJKHomePageJXModel *)model andIndexRow:(NSInteger)row;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
