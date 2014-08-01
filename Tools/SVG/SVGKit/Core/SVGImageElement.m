//
//  SVGImageElement.m
//  SvgLoader
//
//  Created by Joshua May on 24/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SVGImageElement.h"

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
#import "base64.h"

#else
#endif

#if TARGET_OS_IPHONE
#define SVGImage UIImage
#else
#define SVGImage CIImage
#endif

#define SVGImageRef SVGImage*
CGImageRef SVGImageCGImage(SVGImageRef img); //supress warning



CGImageRef SVGImageCGImage(SVGImageRef img)
{
#if TARGET_OS_IPHONE
    return img.CGImage;
#else
    NSBitmapImageRep* rep = [[[NSBitmapImageRep alloc] initWithCIImage:img] autorelease];
    return rep.CGImage;
#endif
}


@implementation SVGImageElement

@synthesize x = _x;
@synthesize y = _y;
@synthesize width = _width;
@synthesize height = _height;

@synthesize href = _href;

+(void)trim
{
    //
}

- (void)dealloc {
    [_href release], _href = nil;

    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)parseAttributes:(NSDictionary *)attributes {
	id value = nil;

	if ((value = [attributes objectForKey:@"x"])) {
		_x = [value floatValue];
	}

	if ((value = [attributes objectForKey:@"y"])) {
		_y = [value floatValue];
	}

	if ((value = [attributes objectForKey:@"width"])) {
		_width = [value floatValue];
	}

	if ((value = [attributes objectForKey:@"height"])) {
		_height = [value floatValue];
	}

	if ((value = [attributes objectForKey:@"href"])) {
		_href = [value retain];
	}
    
    if ((value = [attributes objectForKey:@"transform"])) {//modify by lww
        
        NSRange loc = [value rangeOfString:@"("];
        if( loc.length != 0 )
        {
			NSArray* parameterStrings = [[value substringFromIndex:loc.location+1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
            
            CGFloat a = [(NSString*)[parameterStrings objectAtIndex:0] floatValue];
            CGFloat b = [(NSString*)[parameterStrings objectAtIndex:1] floatValue];
            CGFloat c = [(NSString*)[parameterStrings objectAtIndex:2] floatValue];
            CGFloat d = [(NSString*)[parameterStrings objectAtIndex:3] floatValue];
            CGFloat tx = [(NSString*)[parameterStrings objectAtIndex:4] floatValue];
            CGFloat ty = [(NSString*)[parameterStrings objectAtIndex:5] floatValue];
            
            CGAffineTransform nt = CGAffineTransformMake(a, b, c, d, tx, ty );
            self.transformRelative = CGAffineTransformConcat( self.transformRelative, nt );
        }
	}
}

- (CALayer *)autoreleasedLayer {

	__block CALayer *layer = [CALayer layer];
    layer.name = self.identifier;
    [layer setValue:self.identifier forKey:kSVGElementIdentifier];
    
    CGRect frame = CGRectMake(_x, _y, _width, _height);
    layer.frame = CGRectApplyAffineTransform( frame, self.transformRelative );
 
    
    //modify by lww
    NSData *imageData = nil;

    
    NSArray* keyArray = [NSArray arrayWithObjects:@"data:image/png;", @"data:image/jpeg;", nil];
    
    NSString *encodekey = EncodeKey;
    NSRange range ;
    NSString *tmpKey = nil;
    
    
    for (int i = 0; i<[keyArray count]; ++i) {
        tmpKey = [keyArray objectAtIndex:i];
        if (tmpKey != nil) {
            range = [_href rangeOfString:tmpKey];
            if (range.length != 0) {
                break;
            }
        }
    }
    
    
    int location = range.location;
    int lenght = range.length;
    
    if (lenght != 0) 
    {
        //查找编码的方式
        range = [_href rangeOfString:encodekey];
        location = range.location;
        lenght = range.length;
        
        if (lenght != 0) 
        {
            NSString *stringValue = [_href substringFromIndex:[tmpKey length]+[encodekey length]];
            _href = stringValue;
            
            Byte inputData[[stringValue lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];//prepare a Byte[]
            [[stringValue dataUsingEncoding:NSUTF8StringEncoding] getBytes:inputData];//get the pointer of the data
            size_t inputDataSize = (size_t)[stringValue length];
            size_t outputDataSize = EstimateBas64DecodedDataSize(inputDataSize);//calculate the decoded data size
            Byte outputData[outputDataSize];//prepare a Byte[] for the decoded data
            Base64DecodeData(inputData, inputDataSize, outputData, &outputDataSize);//decode the data
            imageData = [[NSData alloc] initWithBytes:outputData length:outputDataSize];//create a NSData object from the decoded data
        }
    }
    else
    {
        //imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_href]];
        imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_href]];
    }
    
    SVGImageRef image = [SVGImage imageWithData:imageData];
    layer.contents = (id)SVGImageCGImage(image);
    
    [imageData release];
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        
//        SVGImageRef image = [SVGImage imageWithData:imageData];
//        
//        //    _href = @"http://b.dryicons.com/images/icon_sets/coquette_part_4_icons_set/png/128x128/png_file.png";
//        //    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_href]];
//        //    UIImage *image = [UIImage imageWithData:imageData];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            layer.contents = (id)SVGImageCGImage(image);
//        });
//    });
    //modify lww
    return layer;
}








- (void)layoutLayer:(CALayer *)layer {
    
}

@end



























