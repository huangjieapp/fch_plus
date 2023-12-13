//
//  MJKApplicationTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ApplicationType){
    ApplicationTypeModule=0,   //模块
    ApplicationTypeMyApp       //我的应用
    
};





@interface MJKApplicationTableViewCell : UITableViewCell

/** 是否显示编辑按钮*/
@property (nonatomic, copy) void(^showEditButtonBlock)(void);
@property(nonatomic,assign)BOOL isSelected;  //是否编辑
@property(nonatomic,assign)ApplicationType appType;
@property(nonatomic,strong)NSMutableArray*allDatas;
@property(nonatomic,strong)NSString*titleStr;
@property(nonatomic,assign)BOOL canMove;   //我的应用  管理的时候 能拖动
@property(nonatomic,copy)void(^completeMoveBlock)(NSIndexPath*sourceIndexPath,NSIndexPath*destinationIndexPath);



@property(nonatomic,copy)void(^fatherReloadBlock)(NSString *str);
+(CGFloat)calculateCellHeight:(NSMutableArray*)array;
@end
