//
//  NFResourceUtils.h
//
//  Copyright 2012 NextFaze. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FileTypePNG,
    FileTypeJPG,
    FileTypeVideo,
    FileTypePDF,
    FileTypePlist, // FileTypeXML ?
    FileTypeJson,
    FileTypeText,
    FileTypeUnknown
} FileType;

@interface NFResourceUtils : NSObject

+ (FileType)determineFileType:(NSString *)fileName;
+ (void)saveImage:(UIImage *)image withFileName:(NSString *)imageName;
+ (UIImage *)loadImage:(NSString *)fileName;

@end