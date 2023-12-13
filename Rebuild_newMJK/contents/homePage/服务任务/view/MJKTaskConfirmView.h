//
//  MJKTaskConfirmView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/9.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTaskConfirmView : UIView
/** chooseBlock*/
@property (nonatomic, copy) void(^chooseBlock)(NSDictionary *chooseDic);
@end

NS_ASSUME_NONNULL_END
