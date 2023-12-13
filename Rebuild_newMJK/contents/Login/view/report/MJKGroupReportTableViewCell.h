//
//  MJKGroupReportTableViewCell.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/12/7.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKGroupReportTableViewCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *backButton;
@end

NS_ASSUME_NONNULL_END
