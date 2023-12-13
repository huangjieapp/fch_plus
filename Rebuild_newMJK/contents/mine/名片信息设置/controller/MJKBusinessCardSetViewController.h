//
//  MJKBusinessCardSetViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/27.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKBusinessCardSetViewController : DBBaseViewController
/** <#备注#>*/
@property (nonatomic, copy) void(^openBusinessCardBlock)(void);
/** presonImage*/
@property (nonatomic, strong) UIImage *presonImage;
@end

NS_ASSUME_NONNULL_END
