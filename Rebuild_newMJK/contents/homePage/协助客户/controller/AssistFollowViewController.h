//
//  AssistFollowViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/2/8.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDetailInfoModel.h"

typedef NS_ENUM(NSInteger,AssistFollowUp){
	AssistFollowUpAdd=0,   //新增
	AssistFollowUpEdit,
	AssistFollowUpNil
};


@protocol AssistFollowAddEditViewControllerDelegate <NSObject>
-(void)DelegateCompletePopToDo;   //完成pop 之后要做的事情

@end

@interface AssistFollowViewController : DBBaseViewController

//共有
@property(nonatomic,assign)AssistFollowUp Type;
@property(nonatomic,strong)CustomerDetailInfoModel*infoModel;   //C_ID 和 C_HEADIMGURL   C_NAME    C_LEVEL_DD_NAME  C_LEVEL_DD_ID 5个只用到
@property(nonatomic,weak)UIViewController*vcSuper;   //用来 pop回来  不传为pop上一页面

//add独有
@property(nonatomic,strong)NSString*followText;   //跟进的文字

/** <#备注#>*/
@property (nonatomic, strong) NSString *assitStr;


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

@property(nonatomic,assign)id<AssistFollowAddEditViewControllerDelegate>delegate;

@end
