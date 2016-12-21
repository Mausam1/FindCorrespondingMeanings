//
//  WebService.m
//  FindCorrespondingMeanings
//
//  Created by Mausam on 12/20/16.
//  Copyright © 2016 Mausam. All rights reserved.
//

#import "WebService.h"
#import "AFNetworking.h"
#define BaseURL @"http://www.nactem.ac.uk/software/acromine/dictionary.py"

@implementation WebService

+(void)getListOfCorrespondingMeanings:(NSString*)inputString andCompletionHandler:(void (^)(NSArray*resultArray, bool resultStatus))completionHandler
{
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:inputString,@"sf", nil];
    NSString *baseurl = BaseURL;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager autoContentAccessingProxy];
    [manager GET:baseurl parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSArray *arrayMeanings = (NSArray*)responseObject;
        completionHandler(arrayMeanings,true);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionHandler(NULL,false);
    }];
}

@end
