//
//  MJKOrderStatusViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/12.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKOrderStatusViewController : UIViewController
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;
/** <#备注#>*/
@property (nonatomic, copy) void(^backBlack)(NSDictionary *dic);
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_VOUCHERID;
@end

NS_ASSUME_NONNULL_END
