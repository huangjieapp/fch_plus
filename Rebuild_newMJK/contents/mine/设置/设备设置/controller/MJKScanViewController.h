//
//  MJKScanViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/31.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKScanViewController : UIViewController
/** scan Content Back Block*/
@property (nonatomic, copy) void(^scanContentBackBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
