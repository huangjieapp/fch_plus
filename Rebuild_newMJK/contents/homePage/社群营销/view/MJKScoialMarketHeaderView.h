//
//  MJKScoialMarketHeaderView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/26.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKSocialMarketHeaderModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKScoialMarketHeaderView : UIView
/** <#备注#>*/
@property (nonatomic, copy) void(^searchTimeActionBlock)(UIButton *button);

/** MJKSocialMarketHeaderModel*/
@property (nonatomic, strong) MJKSocialMarketHeaderModel *numberModel;
@end

NS_ASSUME_NONNULL_END
