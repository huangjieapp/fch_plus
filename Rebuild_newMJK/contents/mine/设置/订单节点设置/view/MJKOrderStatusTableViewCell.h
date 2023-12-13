//
//  MJKOrderStatusTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/12.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKOrderStatusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
/** <#注释#>*/
@property (nonatomic, strong) NSDictionary *dataDic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
