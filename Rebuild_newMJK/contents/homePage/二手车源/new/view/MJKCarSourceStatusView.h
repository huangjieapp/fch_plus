//
//  MJKCarSourceStatusView.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/19.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCarSourceStatusView : UIView
/** <#注释#> */
@property (nonatomic, strong) UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, strong) UITextField *chooseTextField;


@property (nonatomic, strong) UIButton *trueButton;


@property (nonatomic, strong) UIButton *falseButton;

@property(nonatomic,copy)void(^chooseBlock)(NSString*str,NSString*postValue);
@end

NS_ASSUME_NONNULL_END
