//
//  AudioWrapper.h
//  SGRecorder
//
//  Created by BoBo on 16/12/5.
//  Copyright © 2016年 SG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioWrapper : NSObject
- (void) convertSourcem4a:(NSString *)sourceM4A outPutFilePath:(NSString *) outPutFilePath completion:(void(^)(NSString *))completion;

@end
