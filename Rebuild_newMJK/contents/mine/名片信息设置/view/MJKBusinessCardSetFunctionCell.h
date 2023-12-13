//
//  MJKBusinessCardSetFunctionCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/27.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKBusinessCardSetFunctionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mpLabel;
@property (weak, nonatomic) IBOutlet UILabel *alLabel;
@property (weak, nonatomic) IBOutlet UILabel *scLabel;
@property (weak, nonatomic) IBOutlet UILabel *hdLabel;
@property (nonatomic, weak) UIViewController *rootVC;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** <#备注#>*/
@property (nonatomic, copy) void(^openSwitchAction)(UISwitch *openSwitch);
@end

NS_ASSUME_NONNULL_END
