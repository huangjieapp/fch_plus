//
//  MJKAssignedView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/4.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKAssignedView : UIView
@property (nonatomic, copy) void(^closeAssignedBlock)(void);
@property (nonatomic, copy) void(^allSelectBlock)(void);
@property (nonatomic, copy) void(^trueBlock)(void);
@property (nonatomic, strong) UIButton *allButton;
@end
