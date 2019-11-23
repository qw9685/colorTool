//
//  ccColor.h
//
//  Created by 崔畅 on 2019/9/4.
//  Copyright © 2019年 mac. All rights reserved.
//


#import "ccColor.h"
#import <objc/runtime.h>

#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0 alpha:1.0]

@implementation ccColor

+(void)load{
    //创建对象 + 属性赋值
    [myColor displayCurrentModleProperty];
}

+ (instancetype)shareInstance{
    
    static ccColor *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[super allocWithZone:NULL] init];
    });
    return share;
}

//返回当前类的所有属性
+ (NSArray*)getProperties{
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        const char *propertyCharType = property_getAttributes(property);
        NSString *propertyType = [NSString stringWithUTF8String:propertyCharType];
        
        //过滤非UIColor类型
        if ([propertyType containsString:@"UIColor"]) {
            const char *propertyCharName = property_getName(property);
            NSString *propertyName = [NSString stringWithCString:propertyCharName encoding:NSUTF8StringEncoding];
            [mArray addObject:propertyName];
        }
    }
    
    free(properties);
    return mArray.copy;
}

- (void) displayCurrentModleProperty{

    //赋值
    NSArray *array = [ccColor getProperties];
    for (int i = 0; i < array.count; i ++) {
        NSString* propertyName = array[i];
        [myColor setValue:UIColorFromHex([propertyName integerValue]) forKey:propertyName];
    }
}

@end
