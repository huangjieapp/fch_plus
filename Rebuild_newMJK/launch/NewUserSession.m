//
//  NewUserSession.m
//  GKAPP
//
//  Created by 黄佳峰 on 15/11/6.
//  Copyright © 2015年 黄佳峰. All rights reserved.
//

#import "NewUserSession.h"

#import "SHLoginViewController.h"

@implementation User

@end

@implementation ConfigData

@end


@implementation NewUserSession

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

static NewUserSession *user = nil;
+ (NewUserSession *) instance{
    if (!user) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            user=[[NewUserSession alloc]init];
        });
        
   
        
    }
    
    return user;
}

+ (void)cleanUser{
     [NewUserSession instance];

    user = nil;
    user=[[NewUserSession alloc]init];
    
    
    user.TOKEN=@"";
    user.user.u031Id=@"";
    SHLoginViewController* login=[[SHLoginViewController alloc]initWithNibName:@"SHLoginViewController" bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController=login;
 }




//登录 之后赋值
+ (void)saveUserInfoWithDic:(NSDictionary *)dataDic{
    [NewUserSession instance];
    user=[NewUserSession yy_modelWithDictionary:dataDic];
    
    
}





@end
