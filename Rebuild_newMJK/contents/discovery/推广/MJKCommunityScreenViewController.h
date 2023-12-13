//
//  MJKCommunityScreenViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCommunityScreenViewController : DBBaseViewController
/** <#注释#>*/
@property (nonatomic, assign) BOOL isAddExpand;
/** <#备注#>*/
@property (nonatomic, copy) void(^sureBackBlock)(NSString *str, NSString *nameStr);
@end

NS_ASSUME_NONNULL_END
