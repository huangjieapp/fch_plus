//
//  NSString+Extension.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/8.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
+(NSString *) utf8ToUnicode:(NSString *)string{
    NSUInteger length = [string length];
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++){
        NSMutableString *s = [NSMutableString stringWithCapacity:0];
        unichar _char = [string characterAtIndex:i];
        // 判断是否为英文和数字
        if (_char <= '9' && _char >='0'){
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='a' && _char <= 'z'){
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else{
            // 中文和字符
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
            // 不足位数补0 否则解码不成功
            if(s.length == 4) {
                [s insertString:@"00" atIndex:2];
            } else if (s.length == 5) {
                [s insertString:@"0" atIndex:2];
            }
        }
        [str appendFormat:@"%@", s];
    }
    return str;
}

//编码问题
+(NSString*)DataTOjsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
