//
//  POPRequest.m
//  popSearch
//
//  Created by FishYu on 17/6/22.
//  Copyright © 2017年 pop. All rights reserved.
//

#import "POPRequest.h"
#import <AFNetworking.h>

@interface POPRequest()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@end

@implementation POPRequest

- (void)startRequet{

//    AFNetworkReachabilityManager * manger =[AFNetworkReachabilityManager manager];
//    
//    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"未知");
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//                NSLog(@" 没有联网");
//                
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"3G");
//                [self BeginJavaRequest];
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"wifi");
//                [self BeginJavaRequest];
//                break;
//            default:
//                break;
//        }
//
//        
//        
//        
//    }];
//
//    [manger startMonitoring];
    
    [self BeginJavaRequest];
}



- (void)canelAllRequest{
    __weak AFHTTPSessionManager * manger =[AFHTTPSessionManager manager];
    [manger.operationQueue cancelAllOperations];
}


- (void)BeginJavaRequest{


    
    AFSecurityPolicy * secur=[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [secur setAllowInvalidCertificates:YES];
    secur.validatesDomainName=NO;
    
    __weak AFHTTPSessionManager * manger =[AFHTTPSessionManager manager];
    manger.securityPolicy=secur;
    
    manger.requestSerializer=[AFJSONRequestSerializer serializer];
    manger.responseSerializer=[AFJSONResponseSerializer serializer];
	
	
    /**
     *   设置请求头
     */
    
//
	


//    [manger.requestSerializer setValue:@"ios" forHTTPHeaderField:@"app"];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
 
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval=20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    HUD =[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].delegate.window];
    [[UIApplication sharedApplication].delegate.window addSubview:HUD];
    HUD.delegate =self;
    HUD.dimBackground = YES;
    if (self.isHUD != NO) {//有菊花
        [HUD show:YES];
    }
    
  
    if (self.Method==GET) {
      
     [manger GET:self.url parameters:self.dict progress:^(NSProgress * _Nonnull downloadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               __weak __typeof__(self) weakSelf = self;
            if (weakSelf.blockFinish) {
                 
                weakSelf.blockFinish(responseObject);
            }
            [HUD hide:YES];
            [HUD removeFromSuperview];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             __weak __typeof__(self) weakSelf = self;
            if (weakSelf.blockFalied) {
               
                weakSelf.blockFalied(error);
            }
            [HUD hide:YES];
            [HUD removeFromSuperview];
        } ];
    }else if (self.Method==OTHER){
        manger.responseSerializer=[AFHTTPResponseSerializer serializer];
        [manger GET:self.url parameters:self.dict progress:^(NSProgress * _Nonnull downloadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __weak __typeof__(self) weakSelf = self;
            if (weakSelf.blockFinish) {
                
                weakSelf.blockFinish(responseObject);
            }
          
            [HUD hide:YES];
            [HUD removeFromSuperview];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            __weak __typeof__(self) weakSelf = self;
            if (weakSelf.blockFalied) {
              
                weakSelf.blockFalied(error);
            }
            [HUD hide:YES];
            [HUD removeFromSuperview];
        } ];
    } else if (self.Method==POST){

        NSLog(@"%@",self.url);
        [manger POST:self.url parameters:self.dict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            __weak __typeof__(self) weakSelf = self;
           
            if (weakSelf.blockFinish) {
               
                weakSelf.blockFinish(responseObject);
            }
            [HUD hide:YES];
            [HUD removeFromSuperview];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             __weak __typeof__(self) weakSelf = self;
           
            
            if (weakSelf.blockFalied) {
               
                weakSelf.blockFalied(error);
            }
            [HUD hide:YES];
            [HUD removeFromSuperview];
        }];
    
    }else if (self.Method==PUT){
        [manger PUT:self.url parameters:self.dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __weak __typeof__(self) weakSelf = self;

            if (weakSelf.blockFinish) {
                weakSelf.blockFinish(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            __weak __typeof__(self) weakSelf = self;
            if (weakSelf.blockFalied) {
                weakSelf.blockFalied(error);
            }
            
        }];
    
    }else if (self.Method==DELETE){
        [manger DELETE:self.url parameters:self.dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __weak __typeof__(self) weakSelf = self;

            if (weakSelf.blockFinish) {
                weakSelf.blockFinish(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              __weak __typeof__(self) weakSelf = self;
            if (weakSelf.blockFalied) {
                weakSelf.blockFalied(error);
            }
            
        }];
    
    }else if (self.Method==UPLOAD){
     __weak __typeof__(self) weakSelf = self;
  
        manger.responseSerializer=[AFHTTPResponseSerializer serializer];
      [manger POST:self.url parameters:self.dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (weakSelf.constructingBodyBlock) {
                weakSelf.constructingBodyBlock(formData);
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              __weak __typeof__(self) weakSelf = self;
            if (weakSelf.blockFinish) {
                
                weakSelf.blockFinish(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              __weak __typeof__(self) weakSelf = self;
            if (weakSelf.blockFalied) {
                
                weakSelf.blockFalied(error);
            }
            
        }];
    
    }


   
}



@end
