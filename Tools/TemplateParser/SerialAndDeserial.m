//
//  SerialAndDeserial.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-15.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "SerialAndDeserial.h"
#import "TemplateGlobal.h"
#import <objc/runtime.h>

@implementation SerialAndDeserial

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)deserialize:(NSString *)strObj verId:(NSInteger)versionId {
    
    
    Class cls = [self class];
    
    while (cls != [NSObject class]) {
        unsigned int numberOfIvars = 0;
        // 取得当前class的Ivar数组
        Ivar* ivars = class_copyIvarList(cls, &numberOfIvars);
        for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++) {
            Ivar const ivar = *p;
            // 取得属性名字
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
      
            NSInteger varIndex = -1;
            do { 
                NSRange rangeTemp = NSMakeRange(varIndex + 1, [strObj length] - varIndex - 1);                
                varIndex = [strObj rangeOfString:key options:NSCaseInsensitiveSearch range:rangeTemp].location;
                
                if (varIndex == NSNotFound) {
                    break;
                }
                
                NSString *strTemp = [strObj substringWithRange:NSMakeRange(varIndex + [key length], 1)];
                if ([strTemp isEqual:kEQUAL]) {
                    if (varIndex == 0) {
                        break;
                    } else {
                        NSString *strTemp = [strObj substringWithRange:NSMakeRange(varIndex - 1, 1)];
                        if ([strTemp isEqual:kCOMMA]){
                            break;
                        }
                    }
                }
            }while (1);
            
            
            if (varIndex != NSNotFound) {
                
                NSString *equation = [strObj substringFromIndex:varIndex];
                NSRange sepRange = [equation rangeOfString:kCOMMA];
                if (sepRange.length > 0) {
                    equation = [equation substringToIndex:sepRange.location];
                }
                NSInteger equLoc = [equation rangeOfString:kEQUAL].location;
                NSString *value = [equation substringFromIndex:equLoc + 1];
                // 得到ivar的类型
                const char *type = ivar_getTypeEncoding(ivar);
                switch (type[0]) {
                        
                    case _C_UINT: {
                        if ([value isEqualToString:@"NaN"]) {
                            NSInteger tmp = 1;
                            NSNumber *tmpNum = [NSNumber numberWithUnsignedInteger:tmp];
                            [self setValue:tmpNum forKey:key];
                        } else {
                            NSUInteger tmpInt = [value intValue];
                            NSNumber *tmpNum = [NSNumber numberWithUnsignedInteger:tmpInt];
                            [self setValue:tmpNum forKey:key];
                        }
                    }
                        break;
                    case _C_INT: {
                        NSInteger tmpInt = [value intValue];
                        NSNumber *tmpNum = [NSNumber numberWithInteger:tmpInt];
                        [self setValue:tmpNum forKey:key];
                    }
                        break;
                    case _C_FLT: {                        
                        CGFloat tmpFloat = [value floatValue];
                        NSNumber *tmpNum = [NSNumber numberWithFloat:tmpFloat];
                        [self setValue:tmpNum forKey:key];
                    }
                        break;                        
                    case _C_BOOL: {
                        bool tmpBool = [value boolValue];
                        NSNumber *tmpNum = [NSNumber numberWithBool:tmpBool];
                        [self setValue:tmpNum forKey:key];
                    }
                        break;
                    default: {
                         
                        value = untransferred(value);
                        [self setValue:value forKey:key];
                      
                    }
                        break;
                        
                }                
            }
        }
        cls = class_getSuperclass(cls);
    }
}

- (NSString *) serialize {
    NSString *str = [[[NSString alloc]init] autorelease];
    
    Class cls = [self class];
    
    while (cls != [NSObject class]) {
        
        unsigned int numberOfIvars = 0;
        // 取得当前class的Ivar数组
        Ivar* ivars = class_copyIvarList(cls, &numberOfIvars);
        for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++) {
            Ivar const ivar = *p;
            // 取得属性名字
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            //取得属性值
            id value = [self valueForKey:key];
            // 得到ivar的类型
            const char *type = ivar_getTypeEncoding(ivar);

            NSString *strValue = nil;
            switch (type[0]) {
                    
                case _C_UINT: {
                    NSNumber *num = value;
                    strValue = [NSString stringWithFormat:@"%d", num.unsignedIntegerValue];
                }
                    break;
                case _C_INT: {
                    NSNumber *num = value;
                    strValue = [NSString stringWithFormat:@"%d", num.integerValue];              
                }
                    break;
                case _C_FLT: {
                    NSNumber *num = value;                  
                    NSUInteger count = numberOfDecimal(num.floatValue);
                    if (count == 0){
                        strValue = [NSString stringWithFormat:@"%.0f", num.floatValue]; 
                    } else {
                        strValue = [NSString stringWithFormat:@"%.3f", num.floatValue];  
                    }                    
                }
                    break;                        
                case _C_BOOL: {
                    bool boolValue = value;
                    if (boolValue) {
                        strValue = @"true";                    
                    } else {
                        strValue = @"false";
                    }                    
                }
                    break;
                default: {
                    NSString *strType = [NSString stringWithCString:type encoding:NSNEXTSTEPStringEncoding];
                    if ([strType isEqualToString:@"@\"NSString\""]) {
                        {
                            if (value == nil) {
                                continue;
                            } else {
                                value = transferred(value);
                                strValue = value;
                            }
                        }
                    }
                }
                    break; 
            }
            if (strValue) {                
                str = [str stringByAppendingString:key];
                str = [str stringByAppendingString:kEQUAL];
                str = [str stringByAppendingString:strValue];
                str = [str stringByAppendingString:kCOMMA];                    
            }
        }
        cls = class_getSuperclass(cls);
    }
    
    str = [str substringToIndex:[str length] - 1];
    return str;
}

@end
