//
//  MJKAddOrderNodeViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/14.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
	NodeAdd,
	NodeEdit,
} NodeType;

@interface MJKAddOrderNodeViewController : DBBaseViewController
/** c_id*/
@property (nonatomic, strong) NSString *c_id;
/** 属性类型*/
@property (nonatomic, assign) NodeType type;
/** 轨迹的排序值，只能输入数字*/
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
