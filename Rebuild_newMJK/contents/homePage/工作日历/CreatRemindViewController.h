//
//  CreatRemindViewController.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RemindType){
    RemindTypeAdd=0,   //新增备忘录
    RemindTypeShow,     //备忘录详情
    
    
};


@interface CreatRemindViewController : UIViewController

@property(nonatomic,assign)RemindType type;





//备忘录详情 特有
@property(nonatomic,strong)NSString*C_A41600_C_ID;   //吊用备忘录信息的接口
@property(nonatomic,strong)NSString*C_PROCESS;   //未处理 才会显示按钮 不是未处理不显示按钮



@end
