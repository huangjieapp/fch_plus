//
//  XLNavigationController.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/30.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DBNavigationControllerDelegate <NSObject>

- (void)backBarButtonClick;

@end

@interface DBNavigationController : UINavigationController
@property (weak, nonatomic) id<DBNavigationControllerDelegate> dbDelegate;
- (void)back;
@end
