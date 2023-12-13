//
//  MJKTaskCommentTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKPhotoView.h"
@class MJKCommentsListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKSalesCommentTableViewCell : UITableViewCell
/** MJKCommentsListModel*/
@property (nonatomic, strong) MJKCommentsListModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *reCommentButton;
/** <#注释#> */
@property (nonatomic,weak) UIViewController *rootVC;
/** <#注释#> */
@property (nonatomic,strong) MJKPhotoView *tableCommentDetailPhoto;
/** <#备注#>*/
@property (nonatomic, copy) void(^reCommentActionBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
