//
//  CustomerSignView.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/2.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^getImageBlock)(UIImage*image);

@interface CustomerSignView : UIView

+(instancetype)signViewShowSuccess:(getImageBlock)imageBlock;



@end
