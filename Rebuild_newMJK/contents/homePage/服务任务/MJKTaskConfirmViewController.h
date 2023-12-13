//
//  MJKTaskConfirmViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/12.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceTaskDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKTaskConfirmViewController : UIViewController

@property (nonatomic, strong) ServiceTaskDetailModel *mainDatasModel;
/** taskid*/
@property (nonatomic, strong) NSString *taskID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *vcName;
@end

NS_ASSUME_NONNULL_END
