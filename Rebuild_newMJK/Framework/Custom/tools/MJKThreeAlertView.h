//
//  MJKThreeAlertView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/4/17.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKThreeAlertView : UIView
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)titleStr withText:(NSString *)text withTFTextArray:(NSArray *)titleArray withPlaceholder:(NSArray *)placeholderArray withButtonArray:(NSArray *)buttonArray;
/** pick显示数据*/
@property (nonatomic, strong) NSArray *dataArray;
/** */
@property (nonatomic, copy) void(^buttonActionBlock)(NSString *buttonType, NSString *numberStr, NSString *postionInfoStr, NSString *postionStr);
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;
@end

NS_ASSUME_NONNULL_END
