//
//  SHNeedContactCustomViewController.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/17.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,needContactCustomType){
    needContactCustomTypeTimeOver=0,
    needContactCustomTypeContact
};

@interface SHNeedContactCustomViewController : UIViewController

@property(nonatomic,assign)needContactCustomType type;

+(instancetype)needContactCustomWithType:(needContactCustomType)type;

@end
