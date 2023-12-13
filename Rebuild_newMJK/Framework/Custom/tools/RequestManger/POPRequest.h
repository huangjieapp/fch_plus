//
//  POPRequest.h
//  popSearch
//
//  Created by FishYu on 17/6/22.
//  Copyright © 2017年 pop. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RequestMethod){

    GET=1,
    POST=2,
    PUT=3,
    DELETE=4,
    UPLOAD=5,
    OTHER=6
    
    
};

// 传递数据的block
typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);

//成功的block
typedef void (^Finished)(id responsed);

//是失败的block
typedef void (^Falied)(id error);


@interface POPRequest : NSObject

/**记录接收数据的对象*/
@property (weak) id target;

/// java请求上传多媒体数据请求体的内容
@property (nonatomic, copy) AFConstructingBlock constructingBodyBlock;
@property (nonatomic,copy ) Finished             blockFinish;
@property (nonatomic,copy ) Falied              blockFalied;

/**
 *   JAVAd的请求方式
 */
@property(nonatomic,assign) RequestMethod Method;

@property (nonatomic,copy) NSString * url;

@property (nonatomic,strong) NSMutableDictionary * dict;


/// java请求中。返回的解析类型：JSON、Image、等
@property (nonatomic, weak) AFHTTPResponseSerializer *responseSerializererializer;

/**记录储存相关数据*/
@property (strong) NSData* data;

@property (nonatomic, assign) BOOL isHUD;



- (void)canel;
/// JAVA请求
- (void)startRequet;



- (void)BeginJavaRequest;

- (void)canelAllRequest;
@end
