//
//  MJKIntegralDetailViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKPKSheetModel;
@class CGCSellModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKIntegralDetailViewController : UIViewController
/** <#注释#>*/
@property (nonatomic, strong) NSString *CREATE_TIME_TYPE;
/** 员工id*/
@property (nonatomic, strong) NSString *userID;
/** MJKPKSheetModel*/
@property (nonatomic, strong) MJKPKSheetModel *pkModel;

/** CGCSellModel*/
@property (nonatomic, strong) CGCSellModel *sellModel;
@end

NS_ASSUME_NONNULL_END
