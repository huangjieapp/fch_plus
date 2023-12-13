//
//  MJKTabView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/20.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTabView : UIView
/** <#备注#>*/
@property (nonatomic, strong) UIViewController *rootVC;
/** <#注释#> */
@property (nonatomic, strong) NSString *index;
- (instancetype)initWithFrame:(CGRect)frame andNameItems:(NSArray *)items  withDefaultIndex:(NSInteger)index andIsSaveItem:(BOOL)isSave andClickButtonBlock:(void(^)(NSString *str))buttonClickBlock;
@end

NS_ASSUME_NONNULL_END
