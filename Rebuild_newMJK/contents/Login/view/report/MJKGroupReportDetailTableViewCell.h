//
//  MJKGroupReportDetailTableViewCell.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/12/7.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKGroupReportModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKGroupReportDetailTableViewCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) UIButton *toButton;

@property (nonatomic, strong) NSString *tableType;
/** <#注释#>*/
@property (nonatomic, strong) MJKGroupReportModel *model;
@end

NS_ASSUME_NONNULL_END
