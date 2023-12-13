//
//  MJKTitleTabView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTitleTabView : UIView
/** <#注释#>*/
@property (nonatomic, assign) NSString *selectButtonTitle;
/** <#备注#>*/
@property (nonatomic, copy) void(^chooseTabBlock)(NSString *buttonTitle);
- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray andIsCanChooseTab:(BOOL)canChoose  isSepView:(BOOL)isSep;
@end

NS_ASSUME_NONNULL_END
