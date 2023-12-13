

#import "Global.h"

@implementation Global
+ (BOOL)supportFaceID {

    //获取状态栏高度

    UIView *statusBar;
    if (@available(iOS 13.0, *))
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].windows[0];
        statusBar = [[UIView alloc]initWithFrame:keyWindow.windowScene.statusBarManager.statusBarFrame];
    }
    else
    {
       statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    float statusHeight = statusBar.frame.size.height;

    if (statusHeight > 20){

        return YES;

    }else{

        return NO;

    }

}

+ (NSInteger)supportFaceIDHeight {

    //获取状态栏高度

    UIView *statusBar;
    if (@available(iOS 13.0, *))
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].windows[0];
        statusBar = [[UIView alloc]initWithFrame:keyWindow.windowScene.statusBarManager.statusBarFrame];
    }
    else
    {
       statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    float statusHeight = statusBar.frame.size.height;

   

        return statusHeight + 44;

    

}
@end
