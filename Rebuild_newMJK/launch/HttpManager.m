//
//  HttpManager.m
//  AliShake
//
//  Created by 李鹏博 on 15/10/16.
//  Copyright © 2015年 李鹏博. All rights reserved.
//

#import "HttpManager.h"
#import "AFNetworking.h"


@interface HttpManager ()
/** <#注释#>*/
@property (nonatomic, strong) UIProgressView *pv;
/** <#注释#>*/
@property (nonatomic, strong) UIView *progressBGView;

/** <#注释#>*/
@property (nonatomic, strong) UILabel *progressLabel;
@end


@implementation HttpManager
//封装的get请求
-(void)getDataFromNetworkWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block =newBlock;
#pragma mark -----1
    
     [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    
    //    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    //    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    
    NSString*url = [urlString stringByRemovingPercentEncoding];
    NSString *url_address;
    NSDictionary *tempDict;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"formal"] isEqualToString:@"YES"]) {
        url_address = [url substringToIndex:HTTP_NewADDRESS.length];
        NSString *json_str = [url substringFromIndex:HTTP_NewADDRESS.length + 6];
        NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
        tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    } else {
        url_address = [url substringToIndex:HTTP_TestNewADDRESS.length];
        NSString *json_str = [url substringFromIndex:HTTP_TestNewADDRESS.length + 6];
        NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
        tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    
    
    
    [manager GET:url_address parameters:tempDict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        //        self.block(responseObject,nil);
        NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //        self.block(jsonData,nil);
        //项目里面需要
        
        if ([[jsonData objectForKey:@"message"] isEqualToString:@"该账号已在其他地方登陆"]) {
            MyLog(@"%@",urlString);
            [NewUserSession cleanUser];
            [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
            
        }else{
            
            self.block(jsonData,nil);
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        
         [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
    }];
    
    
    
    
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    //    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //
    //        self.block(responseObject,nil);
    //        [HUD hide:YES];
    //        [HUD removeFromSuperview];
    //
    //
    //
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"Error: %@", error);
    //        self.block(nil,error);
    //        [HUD hide:YES];
    //        [HUD removeFromSuperview];
    //        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
    //
    //
    //    }];
}



//gei 请求 没有HUD
-(void)getDataFromNetworkNOHUDWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block =newBlock;
    
    //    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    //    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    
    
    NSString*url = [urlString stringByRemovingPercentEncoding];
    NSString *url_address;
    NSDictionary *tempDict;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"formal"] isEqualToString:@"YES"]) {
        url_address = [url substringToIndex:HTTP_NewADDRESS.length];
        NSString *json_str = [url substringFromIndex:HTTP_NewADDRESS.length + 6];
        NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
        tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    } else {
        url_address = [url substringToIndex:HTTP_TestNewADDRESS.length];
        NSString *json_str = [url substringFromIndex:HTTP_TestNewADDRESS.length + 6];
        NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
        tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    
    
    
    [manager GET:url_address parameters:tempDict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        self.block(responseObject,nil);
        NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //        self.block(jsonData,nil);
        //项目里面需要
        
        if ([[jsonData objectForKey:@"message"] isEqualToString:@"该账号已在其他地方登陆"]) {
            MyLog(@"%@",urlString);
            [NewUserSession cleanUser];
            [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
            
        }else{
            
            self.block(jsonData,nil);
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
    }];
    
    
    
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    //
    //    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //        self.block(responseObject,nil);
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"Error: %@", error);
    //        self.block(nil,error);
    //
    //        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
    //    }];
    
}







-(void)postDataFromNetworkWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block=newBlock;
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    NSString*url = [urlString stringByRemovingPercentEncoding];
    NSString *url_address;
    NSDictionary *tempDict;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"formal"] isEqualToString:@"YES"]) {
        url_address = [url substringToIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"url"]length] > 0 ? [[[NSUserDefaults standardUserDefaults]objectForKey:@"url"] length] : HTTP_NewADDRESS.length];
        NSString *json_str = [url substringFromIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"url"]length] > 0 ? [[[NSUserDefaults standardUserDefaults]objectForKey:@"url"] length] + 6 :HTTP_NewADDRESS.length + 6];
        NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
        tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    } else {
        url_address = [url substringToIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"url"]length] > 0 ? [[[NSUserDefaults standardUserDefaults]objectForKey:@"url"] length] :HTTP_TestNewADDRESS.length];
        NSString *json_str = [url substringFromIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"url"]length] > 0 ? [[[NSUserDefaults standardUserDefaults]objectForKey:@"url"] length] + 6 :HTTP_TestNewADDRESS.length + 6];
        NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
        tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    
    
    [manager POST:url_address parameters:tempDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        //        self.block(responseObject,nil);
        NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //        self.block(jsonData,nil);
        //项目里面需要
        
        if ([[jsonData objectForKey:@"message"] isEqualToString:@"该账号已在其他地方登陆"]) {
            
            MyLog(@"%@",urlString);
            [NewUserSession cleanUser];
            [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
            
        }else{
            
            self.block(jsonData,nil);
            
        }
        
        
       
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
    }];
    
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    //
    //    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        self.block(responseObject,nil);
    //        [HUD hide:YES];
    //         [HUD removeFromSuperview];
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"Error: %@", error);
    //        self.block(nil,error);
    //        [HUD hide:YES];
    //         [HUD removeFromSuperview];
    //        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
    //    }];
}

//封装的get请求
-(void)getNewDataFromNetworkWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block =newBlock;
#pragma mark -----1
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    if ([urlString rangeOfString:@"/api/system/login"].location == NSNotFound) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[KUSERDEFAULT objectForKey:@"token"]] forHTTPHeaderField:@"Authorization"];
    } else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
    
    NSString *newUrl = [KUSERDEFAULT objectForKey:@"new_url"];
    if (newUrl.length > 0) {
        urlString = [urlString stringByReplacingOccurrencesOfString:HTTP_IP withString:newUrl];
    }
    
    
    [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
//        self.block(responseObject,nil);
//        NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        self.block(jsonData,nil);
        if ([responseObject isKindOfClass:[NSData class]]) {
//            NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *jsonData = (NSDictionary *)responseObject;
//            self.block(jsonData,nil);
            //项目里面需要
            if ([[jsonData objectForKey:@"code"] integerValue] != 200) {
                MyLog(@"%@",urlString);
                [JRToast showWithText:jsonData[@"msg"] duration:5];
                
            }else{
                if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                    MyLog(@"%@",urlString);
                    [NewUserSession cleanUser];
                    [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
                    
                } else {
                self.block(jsonData,nil);
                }
                
            }


        }else{
            if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                MyLog(@"%@",urlString);
                [NewUserSession cleanUser];
                [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
                
            } else {
            self.block(responseObject, nil);
            }
        }


        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];

    }];
    
    

}



//gei 请求 没有HUD
-(void)getNewDataFromNetworkNOHUDWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block =newBlock;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    if ([urlString rangeOfString:@"/api/system/login"].location == NSNotFound && [urlString rangeOfString:@"/api/system/dict/data/list"].location == NSNotFound && [urlString rangeOfString:@"/api/masterdata/districts/getTreeList"].location == NSNotFound) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[KUSERDEFAULT objectForKey:@"token"]] forHTTPHeaderField:@"Authorization"];
    } else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
    
    NSString *newUrl = [KUSERDEFAULT objectForKey:@"new_url"];
    if (newUrl.length > 0) {
        urlString = [urlString stringByReplacingOccurrencesOfString:HTTP_IP withString:newUrl];
    }
    
    [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        self.block(responseObject,nil);
//        NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([responseObject isKindOfClass:[NSData class]]) {
//            NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *jsonData = (NSDictionary *)responseObject;
//            self.block(jsonData,nil);
            //项目里面需要
            if ([[jsonData objectForKey:@"code"] integerValue] != 200) {
                MyLog(@"%@",urlString);
                [JRToast showWithText:jsonData[@"msg"] duration:5];
                
            }else{
                if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                    MyLog(@"%@",urlString);
                    [NewUserSession cleanUser];
                    [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
                    
                } else {
                self.block(jsonData,nil);
                }
                
            }


        }else{
            if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                MyLog(@"%@",urlString);
                [NewUserSession cleanUser];
                [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
                
            } else {
            self.block(responseObject, nil);
            }
        }


        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
    }];

    

}







-(void)postNewDataFromNetworkWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block=newBlock;
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if ([urlString rangeOfString:@"/api/system/login"].location == NSNotFound && [urlString rangeOfString:@"/api/system/a638/sendVerificationCode"].location == NSNotFound && [urlString rangeOfString:@"/api/system/a638/verificationCode"].location == NSNotFound) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[KUSERDEFAULT objectForKey:@"token"]] forHTTPHeaderField:@"Authorization"];
    } else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    }

    NSString *newUrl = [KUSERDEFAULT objectForKey:@"new_url"];
    if (newUrl.length > 0) {
        urlString = [urlString stringByReplacingOccurrencesOfString:HTTP_IP withString:newUrl];
    }
    
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
//        self.block(responseObject,nil);
//        NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([responseObject isKindOfClass:[NSData class]]) {
//            NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *jsonData = (NSDictionary *)responseObject;
//            self.block(jsonData,nil);
            //项目里面需要
            if ([[jsonData objectForKey:@"code"] integerValue] != 200) {
                MyLog(@"%@",urlString);
                [JRToast showWithText:jsonData[@"msg"] duration:5];
                
            }else{
                if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                    MyLog(@"%@",urlString);
                    [NewUserSession cleanUser];
                    [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
                    
                } else {
                self.block(jsonData,nil);
                }
                
            }


        }else{
            if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                MyLog(@"%@",urlString);
                [NewUserSession cleanUser];
                [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
                
            } else {
            self.block(responseObject, nil);
            }
        }



        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];

    }];
    

}


//没有菊花的  post 请求
-(void)postNewDataFromNetworkNoHudWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block=newBlock;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if ([urlString rangeOfString:@"/api/system/login"].location == NSNotFound && [urlString rangeOfString:@"/api/system/a424/versionValidate"].location == NSNotFound && [urlString rangeOfString:@"/api/system/user/validateApp"].location == NSNotFound) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[KUSERDEFAULT objectForKey:@"token"]] forHTTPHeaderField:@"Authorization"];
    } else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
    NSString *newUrl = [KUSERDEFAULT objectForKey:@"new_url"];
    if (newUrl.length > 0) {
        urlString = [urlString stringByReplacingOccurrencesOfString:HTTP_IP withString:newUrl];
    }
       [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
//            NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *jsonData = (NSDictionary *)responseObject;
//            self.block(jsonData,nil);
            //项目里面需要
            if ([[jsonData objectForKey:@"code"] integerValue] != 200) {
                MyLog(@"%@",urlString);
                [JRToast showWithText:jsonData[@"msg"] duration:5];
                
            }else{
                if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                    MyLog(@"%@",urlString);
                    [NewUserSession cleanUser];
                    [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
                    
                } else {
                self.block(jsonData,nil);
                }
                
            }


        }else{
            if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                MyLog(@"%@",urlString);
                [NewUserSession cleanUser];
                [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
                
            } else {
            self.block(responseObject, nil);
            }
        }
        
        
        
//         MyLog(@"返回数据：%@",responseObject);
        
       
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
    }];

    
    
    

}


//没有菊花的  post 请求
-(void)postDataFromNetworkNoHudWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block=newBlock;
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    //    AFHTTPSessionManager* sessionManager = [AFHTTPSessionManager manager];
    //    sessionManager.requestSerializer.timeoutInterval = 20;  //设置请求超时时间
    //    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    //    MyLog(@"链接：%@-+-参数：%@",urlString,parameters);
    
    NSString*url = [urlString stringByRemovingPercentEncoding];
    NSString *url_address;
    NSDictionary *tempDict;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"formal"] isEqualToString:@"YES"]) {
        url_address = [url substringToIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"url"]length] > 0 ? [[[NSUserDefaults standardUserDefaults]objectForKey:@"url"] length] : HTTP_NewADDRESS.length];
        NSString *json_str = [url substringFromIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"url"]length] > 0 ? [[[NSUserDefaults standardUserDefaults]objectForKey:@"url"] length] + 6 :HTTP_NewADDRESS.length + 6];
        NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
        tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    } else {
        url_address = [url substringToIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"url"]length] > 0 ? [[[NSUserDefaults standardUserDefaults]objectForKey:@"url"] length] :HTTP_TestNewADDRESS.length];
        NSString *json_str = [url substringFromIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"url"]length] > 0 ? [[[NSUserDefaults standardUserDefaults]objectForKey:@"url"] length] + 6 :HTTP_TestNewADDRESS.length + 6];
        NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
        tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    [manager POST:url_address parameters:tempDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            //            self.block(jsonData,nil);
            //项目里面需要
            
            if ([[jsonData objectForKey:@"message"] isEqualToString:@"该账号已在其他地方登陆"]) {
                
                MyLog(@"%@",urlString);
                [NewUserSession cleanUser];
                [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
                
            }else{
                
                self.block(jsonData,nil);
                
            }
            
            
        }else{
            self.block(responseObject, nil);
        }
        
        
        
        //         MyLog(@"返回数据：%@",responseObject);
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
    }];
    
    
    
    
    
    //    NSString * url = [urlString st:NSUTF8StringEncoding];
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    //
    //    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        self.block(responseObject,nil);
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"Error: %@", error);
    //        self.block(nil,error);
    //
    //        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
    //    }];
}



-(void)oldPostDataFromNetworkNoHudWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block=newBlock;
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    //    AFHTTPSessionManager* sessionManager = [AFHTTPSessionManager manager];
    //    sessionManager.requestSerializer.timeoutInterval = 20;  //设置请求超时时间
    //    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    //    MyLog(@"链接：%@-+-参数：%@",urlString,parameters);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            //            self.block(jsonData,nil);
            //项目里面需要
            
            if ([[jsonData objectForKey:@"message"] isEqualToString:@"该账号已在其他地方登陆"]) {
                MyLog(@"%@",urlString);
                [NewUserSession cleanUser];
                [JRToast showWithText:@"该账号已在其他地方登录" duration:5];
                
            }else{
                
                self.block(jsonData,nil);
                
            }
            
            
        }else{
            self.block(responseObject, nil);
        }
        
        
        
        //         MyLog(@"返回数据：%@",responseObject);
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
    }];
    
    
    
    
    
    //    NSString * url = [urlString st:NSUTF8StringEncoding];
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    //
    //    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        self.block(responseObject,nil);
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"Error: %@", error);
    //        self.block(nil,error);
    //
    //        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
    //    }];
}







//post 上传图片
-(void)postDataUpDataPhotoWithUrl:(NSString*)urlString parameters:(id)parameters photo:(NSData*)data compliation:(resultBlock)newBlock{
    self.block =newBlock;
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData*data1=data;
        [formData appendPartWithFileData:data1 name:@"file" fileName:@"headimage.png" mimeType:@"png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        MyLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        //        self.block(responseObject,nil);
        NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        self.block(jsonData,nil);
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
        
    }];
    
    
}
//上传头像
-(void)postDataUpDataHeadPhotoWithUrl:(NSString*)urlString parameters:(id)parameters photo:(NSData*)data compliation:(resultBlock)newBlock{
    self.block =newBlock;
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData*data1=data;
        [formData appendPartWithFileData:data1 name:@"avatarfile" fileName:@"avatarfile.png" mimeType:@"png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        MyLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        //        self.block(responseObject,nil);
        NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        self.block(jsonData,nil);
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
        
    }];
    
    
}

-(void)postDataQiNiuUpDataFileWithUrl:(NSString*)urlString parameters:(id)parameters file:(NSData*)data andFileName:(NSString *)fileName andMimeType:(NSString *)type compliation:(resultBlock)newBlock{
    DBSelf(weakSelf);
    self.block =newBlock;
//    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    //    [HUD show:YES];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    if ([urlString rangeOfString:@"/api/system/login"].location == NSNotFound) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[KUSERDEFAULT objectForKey:@"token"]] forHTTPHeaderField:@"Authorization"];
    } else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData*data1=data;
        [formData appendPartWithFileData:data1 name:@"file" fileName:fileName mimeType:type];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressBGView.hidden = NO;
            weakSelf.pv.hidden = NO;
            
            weakSelf.progressLabel.hidden = NO;
            weakSelf.pv.progress = 1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",(1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount) * 100];
        });
        //
        MyLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        //        self.block(responseObject,nil);
        NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        self.block(jsonData,nil);
        [weakSelf.pv removeFromSuperview];
        [weakSelf.progressBGView removeFromSuperview];
        [weakSelf.progressLabel removeFromSuperview];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf.pv removeFromSuperview];
        [weakSelf.progressBGView removeFromSuperview];
        [weakSelf.progressLabel removeFromSuperview];
        NSLog(@"Error: %@", error);
        self.block(nil,error);
//        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
        
    }];
    
    
}

-(void)postDataUpDataFileWithUrl:(NSString*)urlString parameters:(id)parameters file:(NSData*)data andFileName:(NSString *)fileName andMimeType:(NSString *)type compliation:(resultBlock)newBlock{
    DBSelf(weakSelf);
    self.block =newBlock;
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    //    [HUD show:YES];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData*data1=data;
        [formData appendPartWithFileData:data1 name:@"file" fileName:fileName mimeType:type];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressBGView.hidden = NO;
            weakSelf.pv.hidden = NO;
            
            weakSelf.progressLabel.hidden = NO;
            weakSelf.pv.progress = 1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",(1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount) * 100];
        });
        //
        MyLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        //        self.block(responseObject,nil);
        NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        self.block(jsonData,nil);
        [weakSelf.pv removeFromSuperview];
        [weakSelf.progressBGView removeFromSuperview];
        [weakSelf.progressLabel removeFromSuperview];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf.pv removeFromSuperview];
        [weakSelf.progressBGView removeFromSuperview];
        [weakSelf.progressLabel removeFromSuperview];
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
        
    }];
    
    
}

-(void)postDataUpDataMaterialPhotoWithUrl:(NSString*)urlString parameters:(id)parameters photo:(NSArray*)dataArr andMimeType:(NSString *)mimeType compliation:(resultBlock)newBlock{
    self.block =newBlock;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //        NSData*data1=data;
        if ([mimeType isEqualToString:@"png"]) {
            for (int i = 0; i < dataArr.count; i++) {
                NSData *imageData = dataArr[i];
                [formData appendPartWithFileData:imageData name:@"files" fileName:@"headimage.png" mimeType:mimeType];
            }
        } else {
            for (int i = 0; i < dataArr.count; i++) {
                NSData *imageData = dataArr[i];
                if (i == 0) {//第一帧图片
                    [formData appendPartWithFileData:imageData name:@"files" fileName:@"headimage.png" mimeType:@"png"];
                } else {
                    [formData appendPartWithFileData:imageData name:@"files" fileName:@"output.mp4" mimeType:mimeType];
                }
                
            }
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        MyLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        self.block(responseObject,nil);
        NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        self.block(jsonData,nil);
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
        
    }];
    
    
}


//封装的post 带有HTTPRequestHeader
-(void)postDataAndRequestHeaderNoHudWithUrl:(NSString*)urlString parameters:(id)parameters andRequestHeader:(id)requestHeader compliation:(resultBlock)newBlock{
    self.block=newBlock;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    AFSecurityPolicy *security = [AFSecurityPolicy defaultPolicy];
    security.allowInvalidCertificates = YES;
    security.validatesDomainName = NO;
    manager.securityPolicy = security;
    
    
    NSDictionary*headerDic=requestHeader;
    [headerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        
        
    }];
    
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSDictionary*jsonData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            self.block(jsonData,nil);
            
        }else{
            self.block(responseObject, nil);
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
    }];
    
    
    
    
    
}
- (UIView *)progressBGView {
    if (!_progressBGView) {
        _progressBGView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        _progressBGView.backgroundColor = [UIColor blackColor];
        _progressBGView.alpha = .5f;
        _progressBGView.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:_progressBGView];
    }
    return _progressBGView;
}

- (UIProgressView *)pv {
    if (!_pv) {
        _pv = [[UIProgressView alloc]initWithFrame:CGRectMake(20, (KScreenHeight - 8) / 2, KScreenWidth - 40, 8)];
        _pv.hidden = YES;
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 10.0f);
        _pv.transform = transform;//设定宽高
        _pv.trackImage = [UIImage imageNamed:@"progressBG"];
        _pv.progressImage = [UIImage imageNamed:@"progress"];
        [[UIApplication sharedApplication].keyWindow addSubview:_pv];
    }
    return _pv;
}



- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 100, CGRectGetMinY(self.pv.frame) - 50, 100, 50)];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:_progressLabel];
    }
    return _progressLabel;
}
@end
