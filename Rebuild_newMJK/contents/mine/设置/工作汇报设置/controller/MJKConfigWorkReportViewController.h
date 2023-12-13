//
//  MJKConfigWorkReportViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/31.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKConfigWorkReportViewController : UIViewController
/** <#备注#>*/
@property (nonatomic, copy) void(^backSelectArrayBlock)(NSArray *arr);
/** <#注释#>*/
@property (nonatomic, strong) NSArray *workArray;
@end

NS_ASSUME_NONNULL_END
