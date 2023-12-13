//
//  MJKFolderTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/23.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomerLvevelNextFollowModel;
@class MJKFolderModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKFolderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextField *folderNameTF;
/** CustomerLvevelNextFollowModel*/
@property (nonatomic, strong) MJKFolderModel *model;
/** MJKFolderModel*/
@property (nonatomic, strong) MJKFolderModel *folderModel;
/** <#备注#>*/
@property (nonatomic, copy) void(^buttonActionBlock)(NSString *str);
@property (nonatomic, copy) void(^changeValueBlock)(NSString *str);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@end

NS_ASSUME_NONNULL_END
