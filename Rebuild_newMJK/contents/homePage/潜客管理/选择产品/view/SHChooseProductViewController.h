//
//  SHChooseProductViewController.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/14.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,showType){
    showTypeShow=0,  //只能显示不能更改
    showTypeChange
    
};


@interface SHChooseProductViewController : UIViewController

@property(nonatomic,assign)showType*type;

@end
