//
//  ContainerUtility.m
//  ijoyplus
//
//  Created by joyplus1 on 12-9-25.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "ContainerUtility.h"
#import "CMConstants.h"

@implementation ContainerUtility

+ (id)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)setAttribute:(NSObject *)attribute forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:attribute forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSObject *)attributeForKey:(NSString *)key {
    NSObject *object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return object;
}

- (void)clear{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTencentUserLoggedIn];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserLoggedIn];
}
@end