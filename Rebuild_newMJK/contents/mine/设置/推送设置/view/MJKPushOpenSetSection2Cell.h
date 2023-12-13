//
//  MJKPushOpenSetSection2Cell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJKClueListSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKPushOpenSetSection2Cell : UITableViewCell
/** select customer array*/
@property (nonatomic, strong) NSArray *customerArray;
@property (nonatomic, strong) NSArray *nCustomerArray;
/** MJKClueListSubModel*/
@property (nonatomic, strong) MJKClueListSubModel *model;
@property (nonatomic, strong) MJKClueListSubModel *nModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
