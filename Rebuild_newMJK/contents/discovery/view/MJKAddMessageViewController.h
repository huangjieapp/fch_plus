//
//  MJKAddMessageViewController.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoticeInfoModel;

typedef NS_ENUM(NSInteger,noticeType){
    noticeTypeHome=0,    //直接传的allDatas
    noticeTypeManager,   //需要吊接口获取数据
    
};


@interface MJKAddMessageViewController : UIViewController

@property(nonatomic,assign)noticeType type;
@property(nonatomic,strong)NSMutableArray<NoticeInfoModel*>*allDatas;
@property (nonatomic, copy) void(^backAdd)(void);

@end
