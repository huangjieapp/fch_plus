//
//  MJKAddAndEditEmployeesAccountViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2018/12/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EmployeesAccountAdd,
    EmployeesAccountEdit,
} EmployeesAccountType;

NS_ASSUME_NONNULL_BEGIN

@interface MJKAddAndEditEmployeesAccountViewController : DBBaseViewController
/** EmployeesAccountType*/
@property (nonatomic, assign) EmployeesAccountType type;
/** userid*/
@property (nonatomic, strong) NSString *userid;
@end

NS_ASSUME_NONNULL_END
