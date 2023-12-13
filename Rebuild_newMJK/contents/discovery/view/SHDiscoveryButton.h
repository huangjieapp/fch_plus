//
//  SHDiscoveryButton.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/5.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DSButtonInView){
    
    DSButtonInViewTop=0,   //上面的top
    DSButtonInViewBottom
    
};


@interface SHDiscoveryButton : UIButton

@property(nonatomic,strong)UIImageView*mainImageView;
@property(nonatomic,strong)UILabel*mainLabel;


@property(nonatomic,assign)DSButtonInView inViewType;

@end
