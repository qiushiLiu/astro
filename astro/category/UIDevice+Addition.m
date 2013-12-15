//
//  UIDevice+Addition.m
//  Xms
//
//  Created by liuqiushi on 12-4-1.
//  Copyright (c) 2012年 订餐小秘书 . All rights reserved.
//

#import "UIDevice+Addition.h"
#import "NSString+Addition.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface UIDevice (Private)
- (NSString *) macaddress;
@end


@implementation UIDevice (Addition)
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

//- (NSString *) uniqueDeviceIdentifier{
//    NSString *macaddress = [[UIDevice currentDevice] macaddress];
//    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
//    
//    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
//    NSString *uniqueIdentifier = [stringToHash md5];
//    
//    return uniqueIdentifier;
//}

- (NSString *)macAddressForThisDevice{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    if (!macaddress) {
        macaddress = @"1234567890";
    }
    return macaddress;
}

static NSString *kCacheDirForUuid = @"DeviceUniqueGlobalIdentifier";
- (NSString *)uniqueDeviceGuid{
    return [self generateGuid];
}

- (NSString *)generateGuid{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];

    CFRelease(uuidStringRef);
    CFRelease(uuidRef);
    return uuid;
}



@end
