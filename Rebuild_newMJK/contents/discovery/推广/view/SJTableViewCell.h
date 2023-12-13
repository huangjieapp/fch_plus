//
//  SJTableViewCell.h
//  SJVideoPlayer
//
//  Created by 畅三江 on 2018/9/30.
//  Copyright © 2018 畅三江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJPlayView.h"
@class CGCExpandModel;

NS_ASSUME_NONNULL_BEGIN
@interface SJTableViewCell : UITableViewCell
+ (SJTableViewCell *)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight:(CGCExpandModel *)model;
/** CGCExpandModel*/
@property (nonatomic, strong) CGCExpandModel *model;

@property (nonatomic, strong, readonly) SJPlayView *view;
/** <#注释#>*/
@property (nonatomic, strong) UIButton *shareButton;

@end
NS_ASSUME_NONNULL_END
