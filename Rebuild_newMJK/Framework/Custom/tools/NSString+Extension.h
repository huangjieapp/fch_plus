//
//  NSString+Extension.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/8.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)
/* 中文转unicode**/
+(NSString *) utf8ToUnicode:(NSString *)string;
/* unicode转中文**/
+(NSString*)DataTOjsonString:(id)object;
@end

NS_ASSUME_NONNULL_END
