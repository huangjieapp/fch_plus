//
//  MJKAddCustomerTheLabelView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/15.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKAddCustomerTheLabelView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 输入的标签信息*/
@property (nonatomic, copy) void(^inputLabelMessageBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
