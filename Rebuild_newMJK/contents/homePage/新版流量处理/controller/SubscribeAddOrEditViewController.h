//
//  CustomerAddOrEditViewController.h
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import <UIKit/UIKit.h>

@class CGCAppointmentModel;

NS_ASSUME_NONNULL_BEGIN


@interface SubscribeAddOrEditViewController : DBBaseViewController
/** <#注释#> */
@property (nonatomic, strong) NSString *C_ID;
/** <#注释#>*/
@property (nonatomic, copy) void(^returnBlock)(CGCAppointmentModel *model);
@end

NS_ASSUME_NONNULL_END
