//
//  MJKPushOpenFollowSetViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/18.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKCustomReturnSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKPushOpenFollowSetViewController : UIViewController
/** typeNumber*/
@property (nonatomic, strong) NSString *typeNumber;
/** MJKCustomReturnSubModel*/
@property (nonatomic, strong) MJKCustomReturnSubModel *detailModel;

@end

NS_ASSUME_NONNULL_END
