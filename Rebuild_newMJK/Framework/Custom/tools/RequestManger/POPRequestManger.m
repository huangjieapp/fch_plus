//
//  POPRequestManger.m
//  popSearch
//
//  Created by FishYu on 17/6/22.
//  Copyright © 2017年 pop. All rights reserved.
//

#import "POPRequestManger.h"
#import "POPRequest.h"

@interface POPRequestManger ()

@end

@implementation POPRequestManger



+(instancetype)defaultManger{

    static dispatch_once_t pred;
    static POPRequestManger * manger=nil;
    
    dispatch_once(&pred, ^{
        manger=[[POPRequestManger alloc] init];
    });


    return manger;
}

- (void)requestWithMethod:(RequestMethod)method url:(NSString *)url dict:(NSMutableDictionary *)dict target:(id)target finished:(Finished)finished failed:(Falied)falied{
    
    
    POPRequest * request=[[POPRequest alloc]init];
    request.responseSerializererializer=[AFJSONResponseSerializer serializer];
    request.Method=method;
    request.url=url;
    request.dict=dict;
    request.target=target;
    request.blockFinish=finished;
    request.blockFalied=falied;
    [request BeginJavaRequest];
    

}




- (void)requestDownloadWithMethod:(RequestMethod)method url:(NSString *)url dict:(NSMutableDictionary *)dict target:(id)target finished:(Finished)finished failed:(Falied)falied{
    
    
    POPRequest * request=[[POPRequest alloc]init];
    request.responseSerializererializer=[AFHTTPResponseSerializer serializer];
    request.Method=method;
    request.url=url;
    request.dict=dict;
    request.target=target;
    request.blockFinish=finished;
    request.blockFalied=falied;
    [request BeginJavaRequest];
    
    
}

- (void)requestWithNoHudMethod:(RequestMethod)method url:(NSString *)url dict:(NSMutableDictionary *)dict target:(id)target andIsHud:(BOOL)isHud finished:(Finished)finished failed:(Falied)falied {
    
    
    POPRequest * request=[[POPRequest alloc]init];
    request.responseSerializererializer=[AFJSONResponseSerializer serializer];
    request.Method=method;
    request.url=url;
    request.dict=dict;
    request.target=target;
    request.blockFinish=finished;
    request.blockFalied=falied;
    request.isHUD = isHud;
    [request BeginJavaRequest];
    
    
}

- (void)requestUploadWithMethod:(RequestMethod)method url:(NSString *)url dict:(NSMutableDictionary *)dict constructingBodyBlock:(AFConstructingBlock)formData target:(id)target finished:(Finished)finished failed:(Falied)falied{

    POPRequest * request=[[POPRequest alloc]init];
    request.responseSerializererializer=[AFHTTPResponseSerializer serializer];
    request.Method=method;
    request.url=url;
    request.dict=dict;
    request.target=target;
    request.blockFinish=finished;
    request.blockFalied=falied;
    request.constructingBodyBlock=formData;
   
    [request BeginJavaRequest];
   

}


- (void)canelRequest{
    POPRequest * request=[[POPRequest alloc]init];
    [request canelAllRequest];
}

@end
