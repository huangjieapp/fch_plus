//
//  MJKAddOrEditCarSourceViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/18.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomerDetailInfoModel;

typedef enum : NSUInteger {
    CarSourceAdd,
    CarSourceEdit,
} CarType;

NS_ASSUME_NONNULL_BEGIN

@interface MJKAddOrEditCarSourceViewController : DBBaseViewController
/** CarType*/
@property (nonatomic, assign) CarType type;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;
@property (nonatomic, strong) CustomerDetailInfoModel *customerModel;

@end

NS_ASSUME_NONNULL_END
