//
//  VoiceView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/27.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceView : UIView
/** <#备注#>*/
@property (nonatomic, copy) void(^recordBlock)(NSString *str);
/** <#备注#>*/
- (void)start;
@end
