//
//  NaviSearchView.h
//  match
//
//  Created by huangjie on 2022/7/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NaviSearchView : UIView
- (instancetype)initWithView:(UIView *)currentView andReturnBlock:(void(^)(NSString *))returnBlock;
/** <#注释#> */
@property (nonatomic, strong) UITextField *searchTextField;
@end

NS_ASSUME_NONNULL_END
