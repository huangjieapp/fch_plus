//
//  MJKCheckVersionView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/29.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCheckVersionView : UIView
/** updateButtonActioBlock*/
@property (nonatomic, copy) void(^updateButtonActioBlock)(void);
@property (weak, nonatomic) IBOutlet UITextView *updateMessageTextView;
@end

NS_ASSUME_NONNULL_END
