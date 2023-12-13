//
//  CustomerFollowAddEditViewController.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/25.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDetailInfoModel.h"

typedef NS_ENUM(NSInteger,CustomerFollowUp){
    CustomerFollowUpAdd=0,   //新增
    CustomerFollowUpEdit,
	CustomerFollowUpNil
};


@protocol CustomerFollowAddEditViewControllerDelegate <NSObject>
-(void)DelegateCompletePopToDo;   //完成pop 之后要做的事情

@end


@interface CustomerFollowAddEditViewController : DBBaseViewController

//共有
@property(nonatomic,assign)CustomerFollowUp Type;
@property(nonatomic,strong)CustomerDetailInfoModel*infoModel;   //C_ID 和 C_HEADIMGURL   C_NAME    C_LEVEL_DD_NAME  C_LEVEL_DD_ID 5个只用到
@property(nonatomic,weak)UIViewController*vcSuper;   //用来 pop回来  不传为pop上一页面

//add独有
@property(nonatomic,strong)NSString*followText;   //跟进的文字

/** <#注释#>*/
@property (nonatomic, strong) NSString *forRemark;


//编辑独有
@property(nonatomic,strong)NSString*objectID;   //请求跟进详情 用的
@property(nonatomic,assign)BOOL canEdit; //只有edit 中的最后一条能编辑  其他都不能编辑





/*
 * 录音加跟进      Type 新增跟进
 * 有个录音ID  当有值的时候 就传 没值 不传
 */
@property(nonatomic,strong)NSString*recordID;

@property (nonatomic, copy) void(^completeBlock)(void);
@property (nonatomic, copy) void(^successBlock)(void);

@property(nonatomic,weak)id<CustomerFollowAddEditViewControllerDelegate>delegate;

@end
