//
//  VoiceRecordModel.h
//  match5.0
//
//  Created by  huangjie on 2023/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceRecordModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *C_CALL_PHONE;
@property (nonatomic, strong) NSString *C_DEVICE_ID;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_OBJECTTYPE_DD_ID;
@property (nonatomic, strong) NSString *C_OBJECTTYPE_DD_NAME;
@property (nonatomic, strong) NSString *C_OBJECT_ID;
@property (nonatomic, strong) NSString *C_URL;
@property (nonatomic, strong) NSString *D_CALL_DATE_END;
@property (nonatomic, strong) NSString *D_CALL_DATE_START;
@property (nonatomic, strong) NSString *I_CALL_TIME;
@property (nonatomic, strong) NSString *I_CALL_TYPE;
@property (nonatomic, strong) NSString *I_HAS_RECORDING;
@property (nonatomic, strong) NSString *I_SIM_TYPE;
/** <#注释#> */
@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
