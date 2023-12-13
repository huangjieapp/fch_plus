//
//  MJKSocialPresonShareModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/3/3.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKSocialPresonShareModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *accountid;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *coverpicurl;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *faceurl;
@property (nonatomic, strong) NSString *salespicture;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *grpcode;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *loccode;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *salesname;
@property (nonatomic, strong) NSString *orgcode;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *readNumber;
@property (nonatomic, strong) NSString *shareToken;
@property (nonatomic, strong) NSString *shareType;
@property (nonatomic, strong) NSString *showTime;
@property (nonatomic, strong) NSString *storename;
@property (nonatomic, strong) NSString *usertoken;
@property (nonatomic, strong) NSArray *images;


@property (nonatomic, assign) CGFloat height;
@end

NS_ASSUME_NONNULL_END
