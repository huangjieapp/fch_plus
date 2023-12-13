//
//  CustomerAddOrEditViewController.h
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import <UIKit/UIKit.h>
@class CustomerDetailInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface CustomerAddOrEditViewController : DBBaseViewController
/** <#注释#> */
@property (nonatomic, strong) NSString *C_ID;

/** <#注释#> */
@property (nonatomic, strong) CustomerDetailInfoModel *tempCustomerModel;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_A41300_C_ID;

@property (nonatomic, assign) BOOL backTwo;
/** <#注释#> */
@property (nonatomic, weak) UIViewController *rootVC;
@end

NS_ASSUME_NONNULL_END
