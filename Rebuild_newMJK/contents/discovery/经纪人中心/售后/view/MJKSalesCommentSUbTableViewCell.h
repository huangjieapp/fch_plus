//
//  MJKTaskCommentSUbTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKPhotoView.h"
@class MJKCommentsListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKSalesCommentSUbTableViewCell : UITableViewCell
/** MJKTaskCommentModel*/
@property (nonatomic, strong) MJKCommentsListModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** <#注释#> */
@property(nonatomic,weak) UIViewController *rootVC;
/** <#注释#> */
@property (nonatomic,strong) MJKPhotoView *tableCommentDetailPhoto;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
