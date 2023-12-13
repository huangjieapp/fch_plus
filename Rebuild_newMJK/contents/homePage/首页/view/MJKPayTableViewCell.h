//
//  MJKPayTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKPayModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKPayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
/** chooseTabStr*/
@property (nonatomic, strong) NSString *chooseTabStr;
/** MJKPayModel*/
@property (nonatomic, strong) MJKPayModel *payModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
