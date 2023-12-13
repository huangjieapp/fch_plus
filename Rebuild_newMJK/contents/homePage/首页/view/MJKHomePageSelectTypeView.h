//
//  MJKHomePageSelectTypeView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/26.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKHomePageSelectTypeView : UIView
/** type select */
@property (nonatomic, copy) void(^typeSelectBlock)(NSString *str);
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *typeButtonArray;

@end
