//
//  NoticeInfoDetailViewController.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/22.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoticeInfoModel;

typedef NS_ENUM(NSInteger,noticeType){
    noticeTypeHome=0,    //直接传的allDatas
    noticeTypeManager,   //需要吊接口获取数据
    
};


@interface NoticeInfoDetailViewController : UIViewController

@property(nonatomic,assign)noticeType type;
@property(nonatomic,strong)NSMutableArray<NoticeInfoModel*>*allDatas;


@end
