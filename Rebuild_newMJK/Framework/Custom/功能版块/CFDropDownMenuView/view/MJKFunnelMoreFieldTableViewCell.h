//
//  MJKFunnelMoreFieldTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/8.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKFunnelMoreFieldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bottomTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTFLayout;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
/** <#备注#>*/
@property (nonatomic, copy) void(^textChangeBlock)(NSString *str);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
