//
//  WebService.h
//  FindCorrespondingMeanings
//
//  Created by Mausam on 12/20/16.
//  Copyright © 2016 Mausam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

+(void)getListOfCorrespondingMeanings:(NSString*)inputString andCompletionHandler:(void (^)(NSArray*resultArray, bool resultStatus))completionHandler;
@end
