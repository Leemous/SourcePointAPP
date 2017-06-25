//
//  QNUploadUtil.m
//  buycar.yuandian
//
//  Created by 李萌 on 2017/6/2.
//  Copyright © 2017年 tymaker. All rights reserved.
//

#import "QNUploadUtil.h"
#import "QiniuSDK.h"
#import "buycar_yuandian-Swift.h"

@implementation QNUploadUtil

- (void) upload: (NSData*) data fileName:(NSString *)name uploadFinish: (uploadFinishFunc) uploadFinishFunc {
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:name token:uploadToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  if (info.isOK) {
                      isSuccess = @"1";
                      fileHashString = resp[@"hash"];
                      fileKey = resp[@"key"];
                  } else {
                      isSuccess = @"0";
                      responseCode = info.statusCode;
                      errorMsg = info.error.userInfo[@"error"];
                      //NSLog(@"%@", info);
                      //NSLog(@"%@", resp);
                  }
                  uploadFinishFunc(isSuccess, fileKey);
              } option:nil];
}

- (void) setToken: (NSString*) token {
    uploadToken = token;
}

@end
