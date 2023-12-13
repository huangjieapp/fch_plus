//
//  POPRequestManger.h
//  popSearch
//
//  Created by FishYu on 17/6/22.
//  Copyright © 2017年 pop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POPRequest.h"

@interface POPRequestManger : NSObject

/**创建单例对象*/
+ (instancetype)defaultManger;


- (void)requestWithMethod:(RequestMethod)method url:(NSString *)url dict:(NSMutableDictionary*) dict target:(id)target finished:(Finished)finished failed:(Falied)falied;

- (void)requestUploadWithMethod:(RequestMethod)method url:(NSString *)url dict:(NSMutableDictionary *)dict constructingBodyBlock:(AFConstructingBlock)formData target:(id)target finished:(Finished)finished failed:(Falied)falied;

- (void)requestDownloadWithMethod:(RequestMethod)method url:(NSString *)url dict:(NSMutableDictionary *)dict target:(id)target finished:(Finished)finished failed:(Falied)falied;

- (void)requestWithNoHudMethod:(RequestMethod)method url:(NSString *)url dict:(NSMutableDictionary *)dict target:(id)target andIsHud:(BOOL)isHud finished:(Finished)finished failed:(Falied)falied;
- (void)canelRequest;
@end
