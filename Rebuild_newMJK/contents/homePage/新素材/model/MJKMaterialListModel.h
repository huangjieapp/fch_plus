//
//  MJKMaterialListModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/9/16.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKMaterialListModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *accountid;
@property (nonatomic, strong) NSString *addressName;
@property (nonatomic, strong) NSString *bqcontent;
@property (nonatomic, strong) NSString *broadcastStr;
@property (nonatomic, strong) NSString *broadcastType;
@property (nonatomic, strong) NSString *commentnumber;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *flcontent;
@property (nonatomic, strong) NSString *fxpicurl;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *laud;
@property (nonatomic, strong) NSString *laudnumber;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *poster;
@property (nonatomic, strong) NSString *readnumber;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *reservation;
@property (nonatomic, strong) NSString *salesname;
@property (nonatomic, strong) NSString *salespicture;
@property (nonatomic, strong) NSString *shareid;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *store;
@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *video;
@property (nonatomic, strong) NSString *videoHeight;
@property (nonatomic, strong) NSString *videoWidth;

/** <#注释#>*/
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
