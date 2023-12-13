//
//  MJKReportDataTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/11/29.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJReportDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKReportDataTableViewCell : UITableViewCell
/** <#注释#>*/
@property (nonatomic, strong) NSString *titleStr;
/** <#注释#>*/
@property (nonatomic, strong) MJReportDataModel *model;
@property (weak, nonatomic) IBOutlet UIView *topSepView;
@property (weak, nonatomic) IBOutlet UIView *bottomSepView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
