//
//  MJKCompanyInfoTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCompanyInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
/** <#备注#>*/
@property (nonatomic, copy) void(^textChangeBlock)(NSString *str);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
