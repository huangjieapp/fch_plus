//
//  MJKShootView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/12.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKShootView : UIView
- (instancetype)initWithFrame:(CGRect)frame andVC:(UIViewController *)vc;
/** <#备注#>*/
@property (nonatomic, copy) void(^imageFrameBlock)(CGRect frame, NSData *firstImageData);
/** <#备注#>*/
@property (nonatomic, copy) void(^videoDataBlock)(NSData *data);
@end

NS_ASSUME_NONNULL_END
