//
//  MJKYESOrNOTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/4.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKYESOrNOTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noBUtton;
/** <#备注#>*/
@property (nonatomic, copy) void(^yesButtonActionBlock)(void);
@property (nonatomic, copy) void(^noButtonActionBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
