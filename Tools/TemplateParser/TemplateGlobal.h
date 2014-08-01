//
//  TemplateGlobal.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//
 
#import "CoordinateConverter.h"

static NSString * const kPOINTFLAG = @"+P";
static NSString * const kPOINTPATHFLAG = @"+PP";
static NSString * const kCHARCONTOURFLAG = @"+CC";
static NSString * const kONEPARAFLAG = @"+OP";

static NSString * const kLEFTBRACKET = @"(";
static NSString * const kRIGHTBRACKET = @")";
static NSString * const kEQUAL = @"=";
static NSString * const kCOLON = @":";
static NSString * const kPAGEFLAG = @"|";
static NSString * const kCOMMA = @",";
static NSString * const kSEMICOLON = @";";


static NSString * const kPRINTOBJ = @"PrintObj";
static NSString * const kFILEOBJ = @"FileObj";
static NSString * const kIMAGE = @"image";
static NSString * const kIMAGEFRAME = @"ImageFrame";
static NSString * const kTEXT = @"Text";

static NSString * const kCLIPPATHEQUAL = @",clipPath=";
static NSString * const kIMAGEEQUAL = @",image=";
static NSString * const kPARACONTOUREQUAL = @",paraContour";

static NSString * const kPARACONTOUR = @"paraContour";
static NSString * const kCHARCONTOUR = @"CharContour";


NSString *contentInBracket(NSString *src);
NSUInteger numberOfDecimal(CGFloat src);
NSString *float2string(CGFloat src);
NSString *transferred(NSString *src);
NSString * untransferred(NSString *src);
