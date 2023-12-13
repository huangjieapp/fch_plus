//
//  MJKBusinessCardSetCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/27.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKBusinessCardSetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** <#备注#>*/
@property (nonatomic, copy) void(^textChangeBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
