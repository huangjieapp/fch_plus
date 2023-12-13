//
//  MJKChooseBrandViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/12/31.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKChooseCarModelsViewController : UIViewController
/** 选择产品数组*/
@property (nonatomic, strong) NSMutableArray *productArray;
/** 选择的产品返回*/
@property (nonatomic, copy) void(^chooseProductBlock)(NSArray *productArray);
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
/** <#注释#>*/
@property (nonatomic, weak) UIViewController *rootVC;
@end

NS_ASSUME_NONNULL_END
