//
//  QNUploadUtil.h
//  buycar.yuandian
//
//  Created by 李萌 on 2017/6/2.
//  Copyright © 2017年 tymaker. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^uploadFinishFunc)(NSString *isSuccess, NSString *fileKey);

@interface QNUploadUtil : NSObject {
    NSString *uploadToken;      // 上传文件token，需要从服务端获取
    NSString *fileHashString;   // 上传文件成功返回的hash值
    NSString *fileKey;          // 上传文件成功返回的key
    NSString *isSuccess;        // 是否成功：1代表成功，0代表未成功
    int responseCode;           // 上传文件返回码
    NSString *errorMsg;         // 上传文件出错时的错误信息
}

/**
 上传文件，多文件需要循环调用此方法
 @param data 要上传的文件
 */
- (void) upload: (NSData*) data fileName:(NSString *) name uploadFinish: (uploadFinishFunc) uploadFinishFunc;


/**
 设置上传使用的token，从服务端获取
 @param token 上传使用的token
 */
- (void) setToken: (NSString*) token;

@end
