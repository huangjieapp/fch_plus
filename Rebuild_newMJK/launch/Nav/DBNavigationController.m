//
//  XLNavigationController.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/30.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "DBNavigationController.h"
//#import "UIBarButtonItem+XL.h"


@interface DBNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation DBNavigationController

//+ (void)initialize
//{
//    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setBackgroundImage:[UIImage imageNamed:@"navBar_bg_414x70"] forBarMetrics:UIBarMetricsDefault];
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    
//    
//
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];//No 为显示Navigationbar Yes 为隐藏
}



-(void)viewDidLoad{
    NSDictionary *titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor blackColor]};
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.backgroundColor = KNaviColor;
        appearance.titleTextAttributes = titleTextAttributes;
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
    } else {
     // Fallback on earlier versions
     self.navigationBar.barTintColor = KNaviColor;
        self.navigationBar.tintColor = [UIColor whiteColor];
     [self.navigationBar setTitleTextAttributes:titleTextAttributes];
    }
//    [self.navigationBar setBarTintColor:KNaviColor];
//    [self.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self creatPanPop];
//    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    
    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{    
    
    if (self.childViewControllers.count) { // 隐藏导航栏
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        
        // 自定义返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn-返回" highImage:nil isLeft:YES target:self andAction:@selector(back)];
        
        // 如果自定义返回按钮后, 滑动返回可能失效, 需要添加下面的代码
        __weak typeof(viewController)Weakself = viewController;
        self.interactivePopGestureRecognizer.delegate = (id)Weakself;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
	if ([self.topViewController respondsToSelector:@selector(backBarButtonClick)] && _dbDelegate) {
		[_dbDelegate backBarButtonClick];
	} else {
		// 判断两种情况: push 和 present
		if ((self.presentedViewController || self.presentingViewController) && self.childViewControllers.count == 1) {
			
			
			[self dismissViewControllerAnimated:YES completion:nil];
		}else {
			[self popViewControllerAnimated:YES];
		}
	}
	
}

//好像有个方法可以吊起这句话的
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}


-(void)creatPanPop{
    //  这句很核心 稍后讲解
//    id target = self.interactivePopGestureRecognizer.delegate;
//    //  这句很核心 稍后讲解
//    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
//    //  获取添加系统边缘触发手势的View
//    UIView *targetView = self.interactivePopGestureRecognizer.view;
//    
//    //  创建pan手势 作用范围是全屏
//    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
//    fullScreenGes.delegate = self;
//    [targetView addGestureRecognizer:fullScreenGes];
//    
//    // 关闭边缘触发手势 防止和原有边缘手势冲突
//    [self.interactivePopGestureRecognizer setEnabled:NO];
    
    
}

#pragma mark - UIGestureRecognizerDelegate
//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    // 根据具体控制器对象决定是否开启全屏右滑返回
    //    for (UIViewController *viewController in self.blackList) {
    //        if ([self topViewController] == viewController) {
    //            return NO;
    //        }
    //    }
    
    
    
    
    
    // 解决右滑和UITableView左滑删除的冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return self.childViewControllers.count == 1 ? NO : YES;
}


//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if (self.navigationController.viewControllers.count == 1) {
//        return NO;
//    }else{
//        return YES;
//    }
//}

//防止和scrollVIew 的冲突

//-(void)preventConflict{
//    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;//获取所有的手势
//    
//    //当是侧滑手势的时候设置panGestureRecognizer需要UIScreenEdgePanGestureRecognizer失效才生效即可
//    for (UIGestureRecognizer *gesture in gestureArray) {
//        if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//            [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:gesture];
//        }
//    }
//    
//    
//}


@end
