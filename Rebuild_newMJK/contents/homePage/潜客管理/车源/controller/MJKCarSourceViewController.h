//
//  MJKCarSourceViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/16.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCarSourceViewController : UIViewController
/** <#注释#>*/
@property (nonatomic, strong) NSArray *productArray;
/** <#备注#>*/
@property (nonatomic, copy) void(^chooseProductBlock)(NSArray *arr);
@end

NS_ASSUME_NONNULL_END
