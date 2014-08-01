//
//  FPODNSlog.h
//  MobilePOD
//
//  Created by liweiwei on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define PrintLogSwitch 1
#define PrintLogAdmin [NSArray arrayWithObjects: @"ckb",@"lyr",@"lww",nil] 
#define FPODNSLog(key,s,...) [FPODLog  PrintKey:key format:(s),##__VA_ARGS__]

@interface FPODLog : NSObject {}

+(void) PrintKey:key format:(NSString*)format,...;


@end




