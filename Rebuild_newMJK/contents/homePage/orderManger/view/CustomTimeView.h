//
//  CustomTimeView.h
//  match5.0
//
//  Created by huangjie on 2023/1/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTimeView : UIView
/** <#注释#>*/
@property (nonatomic, copy) void(^chooseTimeBlock)(NSString *startTime, NSString *endTime);
@end

NS_ASSUME_NONNULL_END
