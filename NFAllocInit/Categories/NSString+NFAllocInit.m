//
//  NSString+NFAllocInit.m
//
//  Created by Andreas Wulf on 4/10/12.
//  Copyright (c) 2012 NextFaze. All rights reserved.
//

#import "NSString+NFAllocInit.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (NFAllocInit)

- (NSString *)stringByURLEncoding {
	return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG) strlen(cStr), result);
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

- (BOOL)isBlank {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}

// this method is more useful than isBlank, because it will also work with nil receivers, e.g.
//  [nil isNotBlank] == false
//  ["" isNotBlank] == false
//  ["foo" isNotBlank] == true
- (BOOL)isNotBlank {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0;
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray<NSString *> *)matchesForRegex:(NSString *)regexString options:(NSRegularExpressionOptions)options {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:options error:&error];
    if (error == nil) {
        NSArray<NSTextCheckingResult *> *result = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
        NSArray<NSString *> *strings = [result map:^NSString *(NSTextCheckingResult *result) {
            NSRange range = result.range;
            return [self substringWithRange:range];
        }];
        return strings;
    }
    return [NSArray<NSString *> array];
}

+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length {
    // https://stackoverflow.com/a/2633948/883413
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    
    return randomString;
}

@end
