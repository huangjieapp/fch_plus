//
//  MJKUpdatePasswordView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/11.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKUpdatePasswordView : UIView
/** <#备注#>*/
@property (nonatomic, copy) void(^backPasswordBlock)(NSString *oldCode,NSString *newCode);
@end
