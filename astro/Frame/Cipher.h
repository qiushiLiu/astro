//
//  Cipher.h
//  AESCryptoiPhone
//
//  Created by d d on 11-12-15.
//  Copyright (c) 2011年 d. All rights reserved.
//


//#import <Cocoa/Cocoa.h>  
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>  
#import <CommonCrypto/CommonCryptor.h>  

@interface Cipher : NSObject {  
    NSString* cipherKey;  
}  

@property (retain) NSString* cipherKey;  

- (Cipher *) initWithKey:(NSString *) key;  

- (NSData *) encrypt:(NSData *) plainText;  
- (NSData *) decrypt:(NSData *) cipherText;  

- (NSData *) transform:(CCOperation) encryptOrDecrypt data:(NSData *) inputData;  

+ (NSData *) md5:(NSString *) stringToHash;  

@end  
