//
//  XLTabBarViewController.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/30.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "DBTabBarViewController.h"
#import "DBNavigationController.h"

//#import "TJPHomePageViewController.h"
//#import "MDSignedShowViewController.h"
//#import "PullStreamViewController.h"
//#import "MDRankingViewController.h"
//#import "MDPersonCenterViewController.h"

//#import "Main123ViewController.h"
#import "BlurEffectMenu.h"     //跳窗
#import "SHDiscoveryViewController.h"
#import "SHMineViewController.h"


#import "CGCTemplateVC.h"
//#import "SendMessageViewController.h"   //跳转到发送微信和短信
#import "MJKHomePageNewViewController.h"
#import "CGCOrderListVC.h"
#import "PotentailCustomerListViewController.h"
#import "MJKManagerModuleViewController.h"

#import "MJKClueTabViewController.h"//流量tab
#import "MJKCustomerTabViewController.h"//客户tab
#import "MJKTestViewController.h"

@interface DBTabBarViewController ()<UITabBarControllerDelegate,BlurEffectMenuDelegate>

@property(nonatomic,strong)UIViewController*middleVC;
@end

@implementation DBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.tintColor=KNaviColor;
    self.delegate = self;
    [self setupBasic];
    
    UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, KScreenWidth, self.tabBar.bounds.size.height + AdaptTabHeight);
        [[UITabBar appearance] insertSubview:view atIndex:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DBSelf(weakSelf);
    if (self.fileDic != nil) {
        MJKTestViewController *vc = [[MJKTestViewController alloc]init];
        vc.fileDic = self.fileDic;
        [self presentViewController:vc animated:YES completion:^{
            weakSelf.fileDic = nil;
        }];
    }
}

- (void)setupBasic
{
    
	[self addChildViewController:[[MJKHomePageNewViewController alloc] init] notmalimageNamed:@"tabBar0_normal" selectedImage:@"tabBar0_selected" title:@"首页"];
    
	[self addChildViewController:[[MJKClueTabViewController alloc] init] notmalimageNamed:@"导航栏流量图标灰色" selectedImage:@"导航栏流量图标黄色" title:@"流量"];
	
	[self addChildViewController:[[MJKCustomerTabViewController alloc]init]  notmalimageNamed:@"tabBar3_normal" selectedImage:@"tabBar3_selected" title:@"潜客中心"];
    
	[self addChildViewController:[[CGCOrderListVC alloc] init] notmalimageNamed:@"tabBar1_normal" selectedImage:@"tabBar1_selected" title:@"订单"];
	
	
	[self addChildViewController:[[SHMineViewController alloc] init] notmalimageNamed:@"tabBar4_normal" selectedImage:@"tabBar4_selected" title:@"我的"];
}

- (void)addChildViewController:(UIViewController *)childController notmalimageNamed:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title
{
    
    DBNavigationController *nav = [[DBNavigationController alloc] initWithRootViewController:childController];
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childController.title = title;
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    
    [self addChildViewController:nav];
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



#pragma mark 代理方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UINavigationController*naviController=(UINavigationController*)viewController;
    NSArray*array=naviController.viewControllers;
    if ([array[0] isEqual:self.middleVC]) {
        [self ClickToSpring];
        return NO;

    }
    NSArray *jpArray = [NewUserSession instance].appcode;
    
    if ([array[0] isKindOfClass:[CGCOrderListVC class]]) {
        if (![jpArray containsObject:@"crm:a420:list"]){ // && ![jpArray containsObject:@"A40300_X_HOTAPP_0006"]){
            [JRToast showWithText:@"无权限"];
            return NO;
        }
    }
    
    if ([array[0] isKindOfClass:[MJKClueTabViewController class]]) {
        if (![jpArray containsObject:@"crm:a460:list"] && ![jpArray containsObject:@"crm:a414:list"] && ![jpArray containsObject:@"crm:a413:list"]){// && ![jpArray containsObject:@"A40300_X_HOTAPP_0051"]){
            [JRToast showWithText:@"无权限"];
            return NO;
        }
    }
    /**
     [jpArr addObject:@{@"title" : @"潜客", @"code" : @"A40300_X_HOTAPP_0004"}];
 //    [jpArr addObject:@{@"title" : @"协助", @"code" : @"A40300_X_HOTAPP_0010"}];
 //    [jpArr addObject:@{@"title" : @"粉丝", @"code" : @"A40300_X_HOTAPP_0042"}];
     [jpArr addObject:@{@"title" : @"公海", @"code" : @"A40300_X_HOTAPP_0041"}];
     [jpArr addObject:@{@"title" : @"私域", @"code" : @"A40300_X_HOTAPP_0052"}];
     */
    if ([array[0] isKindOfClass:[MJKCustomerTabViewController class]]) {
        if (![jpArray containsObject:@"crm:a415:list"] && ![jpArray containsObject:@"crm:a415_pond:list"]){// && ![jpArray containsObject:@"A40300_X_HOTAPP_0052"]){
            [JRToast showWithText:@"无权限"];
            return NO;
        }
    }
    
    

    return YES;
}





@end
