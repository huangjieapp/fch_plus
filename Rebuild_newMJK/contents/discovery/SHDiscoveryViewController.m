//
//  SHDiscoveryViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/5.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHDiscoveryViewController.h"
#import "SHDiscoveryButton.h"

#import "SHWechatMarketingViewController.h"
#import "ShakeitViewController.h"
//#import "MJKOnlineMainHallViewController.h"    //在线展厅

#import "BlurEffectMenu.h"     //跳窗
#import "CGCTemplateVC.h"
#import "DBNavigationController.h"

#import "CGCIntegralStoreVC.h"//积分商城
#import "CGCBrokerCenterVC.h"//经纪人中心
#import "CGCVerificationCenterVC.h"//核销中心
#import "CGCExpandVC.h"//推广

#import "CGCSelCustomerVC.h"

@interface SHDiscoveryViewController ()<BlurEffectMenuDelegate>

@property(nonatomic,strong)UIScrollView*scrollView;
@property(nonatomic,strong)UIView*topMainView;
@property(nonatomic,strong)UIView*bottomMainView;


@end

@implementation SHDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.scrollView.alwaysBounceVertical=YES;
    [self.view addSubview:self.scrollView];
    
    [self makeUI];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark  --UI
-(void)makeUI{
    UIView*topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    topView.backgroundColor=DBColor(247, 247, 247);
    [self.scrollView addSubview:topView];
    UILabel*topLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, KScreenWidth/2, 18)];
    topLabel.textColor=[UIColor grayColor];
    topLabel.font=[UIFont systemFontOfSize:12];
    topLabel.text=@"脉居客";
//    [topView addSubview:topLabel];
    
    UIView*topMainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];   //高需要修改。
    topMainView.backgroundColor=[UIColor whiteColor];
    self.topMainView=topMainView;
    [self.scrollView addSubview:topMainView];
//    NSDictionary*dict2=@{@"image":@"积分商城",@"title":@"积分商城"};
//    NSDictionary*dict3=@{@"image":@"核销中心",@"title":@"核销中心"};
//    NSDictionary*dict4=@{@"image":@"经纪人",@"title":@"经纪人中心"};
    NSDictionary*dict5=@{@"image":@"新话术模板",@"title":@"话术模板"};
    NSDictionary*dict6=@{@"image":@"推广",@"title":@"推广"};
    NSArray*array;
    if ([[NewUserSession instance].appcode containsObject:@"APP011_0001"]) {
        array = @[/*dict2,dict3,dict4,*/dict5,dict6];
    } else {
        array = @[dict5];
    }
    

    [self creatContentViewWithMainView:topMainView andData:array];
    
    
    
    
    
       
    
    
    
    //下面的视图
//    UIView*BottomView=[[UIView alloc]initWithFrame:CGRectMake(0,topMainView.bottom, KScreenWidth, 20)];
//    BottomView.backgroundColor=DBColor(247, 247, 247);
//    [self.scrollView addSubview:BottomView];
//    UILabel*bottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, KScreenWidth/2, 18)];
//    bottomLabel.textColor=[UIColor grayColor];
//    bottomLabel.font=[UIFont systemFontOfSize:12];
//    bottomLabel.text=@"第三方服务";
//    [BottomView addSubview:bottomLabel];
//
//    UIView*bottomMainView=[[UIView alloc]initWithFrame:CGRectMake(0,BottomView.bottom, KScreenWidth, 10)];
//    bottomMainView.backgroundColor=[UIColor whiteColor];
//    self.bottomMainView=bottomMainView;
//    [self.scrollView addSubview:bottomMainView];
    
    
//    NSDictionary*dictt0=@{@"image":@"车价计算器",@"title":@"车价计算器"};
//    NSDictionary*dictt1=@{@"image":@"保险计算器",@"title":@"保险计算器"};
//    NSArray*otherArray=@[dictt0,dictt1];
//    [self creatContentViewWithMainView:bottomMainView andData:otherArray];
    
    
    
}


-(void)creatContentViewWithMainView:(UIView*)topMainView andData:(NSArray*)array{
    
    for (int i=0; i<array.count; i++) {
        NSInteger vertical=i/3;
        NSInteger horizontal=i%3;
        NSInteger itWithAndHeight=KScreenWidth/3;
        
        SHDiscoveryButton*button=[[SHDiscoveryButton alloc]initWithFrame:CGRectMake(itWithAndHeight*horizontal, itWithAndHeight*vertical, itWithAndHeight, itWithAndHeight)];
        NSDictionary*dict=array[i];
        button.mainImageView.image=[UIImage imageNamed:dict[@"image"]];
        button.mainLabel.text=dict[@"title"];
        button.tag=i+1000;
        if ([topMainView isEqual:self.topMainView]) {
            button.inViewType=DSButtonInViewTop;
            
        }else if ([topMainView isEqual:self.bottomMainView]){
            button.inViewType=DSButtonInViewBottom;
           
        }
        
        
        
        [button addTarget:self action:@selector(clickDSButton:)];
        [topMainView addSubview:button];
        
        
    }
    
    
    NSInteger maxVertical=(array.count-1)/3;
    topMainView.height=(maxVertical+1)*KScreenWidth/3;
    
    //分割线   竖线
    NSInteger lineVertical;
    NSInteger lineHorizontal=(array.count-1)/3;
    
    if (array.count==0) {
        lineVertical=0;
    }else if (array.count==1){
        lineVertical=1;
    }else{
        lineVertical=2;
    }
    
    
    
    for (NSInteger i=1; i<=lineVertical; i++) {
        UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(i*KScreenWidth/3, 0, 1, KScreenWidth/3*(lineHorizontal+1))];
        lineView.backgroundColor=DBColor(247, 247, 247);
        [topMainView addSubview:lineView];
        
    }
    
    
    for (NSInteger i=0; i<=lineHorizontal; i++) {
        UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenWidth/3*(i+1), KScreenWidth, 1)];
        lineView.backgroundColor=DBColor(247, 247, 247);
        [topMainView addSubview:lineView];
        
        
    }
}

#pragma mark --判断是否接入公众号的请求
- (void)getDataForWechatIsPublic {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A42700WebService-validate"];
	[dict setObject:@{} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			if ([data[@"Flag"] isEqualToString:@"true"]) {
				SHWechatMarketingViewController*vc=[[SHWechatMarketingViewController alloc]init];
				[weakSelf.navigationController pushViewController:vc animated:YES];
			} else {
				[JRToast showWithText:@"未接入公众号"];
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}


#pragma mark  --touch
-(void)clickDSButton:(SHDiscoveryButton*)sender{
	
	
    switch (sender.inViewType) {
        case DSButtonInViewTop:{
            NSInteger number=sender.tag-1000;
            MyLog(@"%lu",number);
            /*if (number==0) { //积分商城
				
                CGCIntegralStoreVC * cvc=[[CGCIntegralStoreVC alloc] init];
                [self.navigationController pushViewController:cvc animated:NO];
                
            } else if (number==1){ //核销中心
                
                CGCVerificationCenterVC * cvc=[[CGCVerificationCenterVC alloc] init];
                [self.navigationController pushViewController:cvc animated:NO];
                
            }else if (number==2){ //经纪人中心
                
                CGCBrokerCenterVC * cvc=[[CGCBrokerCenterVC alloc] init];
                [self.navigationController pushViewController:cvc animated:NO];
                
            }else*/ if (number==0){
                
                //话术模板 4
                //                [self ClickToSpring];
                DBSelf(weakSelf);
                UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *wechat = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    CGCTemplateVC *myView=[[CGCTemplateVC alloc] init];
                    myView.templateType=CGCTemplateWeiXin;
                    DBNavigationController *nav=[[DBNavigationController alloc]initWithRootViewController:myView];
                    [weakSelf presentViewController:nav animated:YES completion:nil];
                }];
                UIAlertAction *message = [UIAlertAction actionWithTitle:@"短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    CGCTemplateVC *myView=[[CGCTemplateVC alloc] init];
                    myView.templateType=CGCTemplateMessage;
                    DBNavigationController *nav=[[DBNavigationController alloc]initWithRootViewController:myView];
                    [weakSelf presentViewController:nav animated:YES completion:nil];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertV addAction:cancel];
                [alertV addAction:message];
                [alertV addAction:wechat];
                [self presentViewController:alertV animated:YES completion:nil];
            }else if (number==1){
                
//                CGCSelCustomerVC *cvc=[[CGCSelCustomerVC alloc] init];
//                [self.navigationController pushViewController:cvc animated:NO];
//
//                return;
                //推广 3
                if ([[NewUserSession instance].appcode containsObject:@"APP011_0001"]) {
                    CGCExpandVC *zvc=[[CGCExpandVC alloc] init];
                    [self.navigationController pushViewController:zvc animated:NO];
                } else {
                    [JRToast showWithText:@"账号无权限"];
                }
                
            }
            break;}
        case DSButtonInViewBottom:{
            MyLog(@"%lu",sender.tag-1000);
            NSInteger number=sender.tag-1000;

            if (number==0) {
                //车价计算器
                 [JRToast showWithText:@"敬请期待"];
                
            }else if (number==1){
                //保险计算器
                 [JRToast showWithText:@"敬请期待"];
            }
            
            
            
            break;}
   
        default:
            break;
    }
    
    
}

//跳窗的UI
-(void)ClickToSpring{
    BlurEffectMenuItem *addMattersItem=[[BlurEffectMenuItem alloc]init];
    [addMattersItem setTitle:@"微信"];
    [addMattersItem setIcon:[UIImage imageNamed:@"微信-1"]];
    
    BlurEffectMenuItem *addSchedulesItem=[[BlurEffectMenuItem alloc]init];
    [addSchedulesItem setTitle:@"短信"];
    [addSchedulesItem setIcon:[UIImage imageNamed:@"短信-1"]];
    
    BlurEffectMenuItem *setupChatItem=[[BlurEffectMenuItem alloc]init];
    [setupChatItem setTitle:@"公众号"];
    [setupChatItem setIcon:[UIImage imageNamed:@"公众号"]];
    
    
    BlurEffectMenu *menu=[[BlurEffectMenu alloc]initWithMenus:@[addMattersItem,addSchedulesItem,setupChatItem]];
    [menu setDelegate:self];
    menu.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [menu setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:menu animated:YES completion:nil];
    
    
    
}

#pragma mark - BlurEffectMenu Delegate
- (void)blurEffectMenuDidTapOnBackground:(BlurEffectMenu *)menu{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)blurEffectMenu:(BlurEffectMenu *)menu didTapOnItem:(BlurEffectMenuItem *)item{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"item.title:%@",item.title);
    if ([item.title isEqualToString:@"微信"]) {
        
        CGCTemplateVC *myView=[[CGCTemplateVC alloc] init];
        myView.templateType=CGCTemplateWeiXin;
        DBNavigationController *nav=[[DBNavigationController alloc]initWithRootViewController:myView];
        [self presentViewController:nav animated:YES completion:nil];
        
        
    }else if ([item.title isEqualToString:@"短信"]){
        
        CGCTemplateVC *myView=[[CGCTemplateVC alloc] init];
        myView.templateType=CGCTemplateMessage;
        DBNavigationController *nav=[[DBNavigationController alloc]initWithRootViewController:myView];
        [self presentViewController:nav animated:YES completion:nil];
        
        
    }else if ([item.title isEqualToString:@"公众号"]){
        CGCTemplateVC *myView=[[CGCTemplateVC alloc] init];
        myView.templateType=CGCTemplatePublic;
        DBNavigationController *nav=[[DBNavigationController alloc]initWithRootViewController:myView];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
}


@end
