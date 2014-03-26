//
//  Cipher.m
//  AESCryptoiPhone
//
//  Created by d d on 11-12-15.
//  Copyright (c) 2011年 d. All rights reserved.
//

#import "Cipher.h"

@implementation Cipher  

@synthesize cipherKey;  // NOT USED in encrypt

- (Cipher *) initWithKey:(NSString *) key {  
    self = [super init];  
    if (self) {  
        [self setCipherKey:key];  
    }  
    return self;  
}  

- (NSData *) encrypt:(NSData *) plainText {  
    return [self transform:kCCEncrypt data:plainText];  
}  

- (NSData *) decrypt:(NSData *) cipherText {  
    return [self transform:kCCDecrypt data:cipherText];  
}  

- (NSData *) transform:(CCOperation) encryptOrDecrypt data:(NSData *) inputData {  
    
    // kCCKeySizeAES128 = 16 bytes  
    // CC_MD5_DIGEST_LENGTH = 16 bytes  

    // NOTE: we doesn't calculate the with md5, BUT we do NEED a NSData instance to 
    // NSData* secretKey = [Cipher md5:cipherKey];  
    // NSLog(@"bytes in hex: %@", [secretKey description]);
    
    // REF.http://stackoverflow.com/questions/2338975/convert-hex-data-string-to-nsdata-in-objective-c-cocoa
    NSString *command = @"6aa89cd9 86019bc6 2b81700c d8346906";
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < 16; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1]; 
    }
//    NSLog(@"description %@", [commandToSend description]);
//    NSLog(@"Raw string is '%s' (length %d)\n", [secretKey bytes], [secretKey length]);
    
    CCCryptorRef cryptor = NULL;  
    CCCryptorStatus status = kCCSuccess;  
    
    uint8_t iv[kCCBlockSizeAES128];  
    memset((void *) iv, 0x0, (size_t) sizeof(iv));  
    
    status = CCCryptorCreate(encryptOrDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,  
                             [commandToSend bytes], kCCKeySizeAES128, iv, &cryptor);  
    
    if (status != kCCSuccess) {  
        return nil;  
    }  
    
    size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t)[inputData length], true);  
    
    void * buf = malloc(bufsize * sizeof(uint8_t));  
    memset(buf, 0x0, bufsize);  
    
    size_t bufused = 0;  
    size_t bytesTotal = 0;  
    
    status = CCCryptorUpdate(cryptor, [inputData bytes], (size_t)[inputData length],  
                             buf, bufsize, &bufused);  
    
    if (status != kCCSuccess) {  
        free(buf);  
        CCCryptorRelease(cryptor);  
        return nil;  
    }  
    
    bytesTotal += bufused;  
    
    status = CCCryptorFinal(cryptor, buf + bufused, bufsize - bufused, &bufused);  
    
    if (status != kCCSuccess) {  
        free(buf);  
        CCCryptorRelease(cryptor);  
        return nil;  
    }  
    
    bytesTotal += bufused;  
    
    CCCryptorRelease(cryptor);  
    [commandToSend release];
    return [NSData dataWithBytesNoCopy:buf length:bytesTotal];  
}  

+ (NSData *) md5:(NSString *) stringToHash {  
    
    const char *src = [stringToHash UTF8String];  
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];  
    
    CC_MD5(src, (int)strlen(src), result);
    
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];  
}  

@end  
