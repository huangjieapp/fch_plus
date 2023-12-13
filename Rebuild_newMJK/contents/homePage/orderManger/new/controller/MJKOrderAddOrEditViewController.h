//
//  MJKOrderAddOrEditViewController.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/27.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCCustomModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,OrderType){
    orderTypeAdd=0,
    orderTypeEdit,
};

@interface MJKOrderAddOrEditViewController : DBBaseViewController
/** <#注释#> */
@property (nonatomic, assign) OrderType Type;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_ID;
/** <#注释#> */
@property (nonatomic, strong) CGCCustomModel *customerModel;
/** <#注释#> */
@property (nonatomic, weak) UIViewController *rootVC;
/** <#注释#> */
@property (nonatomic, strong) NSString *vcName;
@end

NS_ASSUME_NONNULL_END
