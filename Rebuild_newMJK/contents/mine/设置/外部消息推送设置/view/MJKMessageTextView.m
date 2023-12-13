//
//  MJKMessageTextView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/17.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKMessageTextView.h"

@implementation MJKMessageTextView

- (instancetype)initWithStartPoint:(CGPoint)point contentWidth:(CGFloat)contentWidth text:(NSString *)textMessage font:(UIFont *)font textColor:(UIColor *)textColor lineGap:(CGFloat)lineGap wordGap:(CGFloat)wordGap  inputLocations:(NSArray *)locationArray {
    if (self == [super init]) {
        UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, contentWidth, 300)];
        testLabel.font = font;
        //多行显示
        testLabel.numberOfLines = 0;
        [self addSubview:testLabel];
        
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:textMessage];
        for (int i = 0; i < locationArray.count; i++) {
            NSDictionary *dic = locationArray[i];
            NSInteger range = [dic[@"range"] integerValue];
            CGFloat width = [dic[@"width"] floatValue];
            
            [attributedString addAttribute:NSKernAttributeName value:@(width) range:NSMakeRange(range, 1)];
            
            NSString *str = textMessage;
            str = [str substringToIndex:range + 1];
            
            CGRect rect = [str boundingRectWithSize:CGSizeMake(KScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
            NSLog(@"");
            
//            CGFloat marginX;
//            if (<#condition#>) {
//                <#statements#>
//            }
//            UITextField *textF = [UITextField alloc]initWithFrame:CGRectMake(rect.size.width, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//            
        }
        testLabel.attributedText = attributedString;
        
        
        
        
        
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame  {
    frame = CGRectMake(0, 0, KScreenWidth, 300);
    [super setFrame:frame];
}


@end
