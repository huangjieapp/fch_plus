//
//  MJKCompanyAddressTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKCompanyInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKCompanyAddressTableViewCell : UITableViewCell
/** MJKCompanyInfoModel*/
@property (nonatomic, strong) MJKCompanyInfoModel *model;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (nonatomic, copy) void(^textChangeBlock)(NSString *str);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
