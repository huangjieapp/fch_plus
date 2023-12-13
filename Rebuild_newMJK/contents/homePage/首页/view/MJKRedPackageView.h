//
//  MJKRedPackageView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/30.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKRedPackageModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKRedPackageView : UIView
/** MJKRedPackageModel*/
@property (nonatomic, strong) MJKRedPackageModel *model;
/**  点开红包   */
@property (nonatomic, copy) void(^openRedPackageBlock)(void);

@end

NS_ASSUME_NONNULL_END
