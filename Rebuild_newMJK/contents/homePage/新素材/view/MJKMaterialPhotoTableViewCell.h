//
//  MJKMaterialPhotoTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/9/17.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKMaterialPhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *materialImageView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
