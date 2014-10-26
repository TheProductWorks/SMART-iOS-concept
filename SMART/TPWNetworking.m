//
//  TPWNetworking.m
//  SMART
//
//  Created by John Smyth on 26/10/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import "TPWNetworking.h"

@implementation TPWNetworking
static AFHTTPRequestOperationManager *manager = nil;

+ (AFHTTPRequestOperationManager *)manager {
    if (manager == nil) {
        NSDictionary *envDictionary = [[NSProcessInfo processInfo] environment];
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[envDictionary objectForKey:@"API_URL"]]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:[envDictionary objectForKey:@"API_KEY"] forHTTPHeaderField:@"Api-Key"];
        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"Auth-Token"];
    }
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"Auth-Token"];

    return manager;
}

@end
