//
//  MJKClueNewProcessTypeView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKClueNewProcessTypeView : UIView
- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray;
/** <#备注#>*/
@property (nonatomic, copy) void(^selectTypeBlock)(UIButton *sender);

/** <#注释#>*/
@property (nonatomic, strong) NSArray *titleArray;
@end

NS_ASSUME_NONNULL_END
