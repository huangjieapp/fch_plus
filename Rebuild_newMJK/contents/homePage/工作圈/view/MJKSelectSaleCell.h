//
//  MJKSelectSaleCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/28.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKClueListSubModel;


NS_ASSUME_NONNULL_BEGIN

@interface MJKSelectSaleCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (nonatomic, strong) MJKClueListSubModel *subModel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@end

NS_ASSUME_NONNULL_END
