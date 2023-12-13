//
//  MJKApprolViewRemark.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/11/9.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKApprolViewRemark : UIView
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;
@property (weak, nonatomic) IBOutlet UIButton *trueButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@property (copy, nonatomic) void(^changeTextBlock)(NSString *text);

@end

NS_ASSUME_NONNULL_END
