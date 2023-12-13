//
//  MJKPayDetailInfoTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKPayModel;
NS_ASSUME_NONNULL_BEGIN

@interface MJKPayDetailInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
/** <#注释#>*/
@property (nonatomic, strong) NSString *chooseTabStr;
/** MJKPayModel*/
@property (nonatomic, strong) MJKPayModel *payModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@end

NS_ASSUME_NONNULL_END
