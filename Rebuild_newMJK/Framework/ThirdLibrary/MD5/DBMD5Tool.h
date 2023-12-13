//
//  DBMD5Tool.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/6/29.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBMD5Tool : NSObject

/*****
当前项目需要的
 创建： shen
 MD5 加密
 *****/

+(NSString *) md5: (NSString *) inPutText ;








/**
 *  MD5加密, 32位 小写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForLower32Bate:(NSString *)str;

/**
 *  MD5加密, 32位 大写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForUpper32Bate:(NSString *)str;

/**
 *  MD5加密, 16位 小写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForLower16Bate:(NSString *)str;

/**
 *  MD5加密, 16位 大写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForUpper16Bate:(NSString *)str;

@end
