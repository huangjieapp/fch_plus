//
//  MJKChooseEmployeesViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/5.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKClueListSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKChooseEmployeesViewController : DBBaseViewController
/** <#注释#>*/
@property (nonatomic, strong) NSString *isAllEmployees;
/** <#注释#>*/
@property (nonatomic, weak) UIViewController *rootVC;
/** <#注释#> */
@property (nonatomic, strong) NSString *allUser;
/** 固定"无提示" 则不需要alertview提示*/
@property (nonatomic, strong) NSString *noticeStr;
/** <#注释#>*/
@property (nonatomic, strong) NSString *alertName;
@property (nonatomic, strong) NSString *employeesType;
/** <#备注#>*/
@property (nonatomic, copy) void(^chooseEmployeesBlock)(MJKClueListSubModel *model);
@end

NS_ASSUME_NONNULL_END
