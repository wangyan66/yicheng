//
//  ZWAPIRequestTool.m
//  Qimokaola
//
//  Created by Administrator on 16/8/28.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWAPIRequestTool.h"


@implementation ZWAPIRequestTool
    

 //64base字符串转图片
+ (UIImage *)stringToImage:(NSString *)str {
        NSData * imageData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];UIImage *photo = [UIImage imageWithData:imageData ];
    return photo;
    
}

// 图片转64base字符串
+ (NSString *)imageToString:(UIImage *)image {
    NSData *imagedata = UIImageJPEGRepresentation(image, 1.0f);
    NSString *image64 = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return image64;
    
}

+ (void)requestSendCodeWithPhone:(NSString *)phone result:(APIRequestResult)result{
    NSLog(@"shit");
    [ZWAPIRequestTool requestWithAPI:@"http://35.241.126.186:8080/travel/getValicode" parameters:@{@"phone":@"13235910535"} result:result];
}
+ (void)requestPictureTranslateByPicture:(UIImage *)image result:(APIRequestResult)result{
    NSString *str2 = [self imageToString:image];
    NSString *qianzhui =@"data:image/png;base64,";
    NSString *str = [qianzhui stringByAppendingString:str2];
    [ZWAPIRequestTool requestWithAPI:@"http://35.241.126.186:8080/travel/translateImage"parameters:@{@"isInJapan":@"1",@"imgStr":str} result:result];
}
+(void)requestTextTranslateByText:(NSString *)text sourceLan:(NSString *)sl    targetLan:(NSString *)tl result:(APIRequestResult)result{
    
    [ZWAPIRequestTool requestWithAPI:@"http://35.241.126.186:8080/travel/translate" parameters:@{@"text":text,@"sourceLanguage":sl,@"targetLanguage":tl} result:result];
}
+ (void)requestTouristRecognizeBy:(UIImage *)image result:(APIRequestResult)result{
    NSString *str2 = [self imageToString:image];
    NSString *qianzhui =@"data:image/png;base64,";
    NSString *str = [qianzhui stringByAppendingString:str2];
    
    [ZWAPIRequestTool requestWithAPI:@"http://35.241.126.186:8080/travel/vision" parameters:@{@"isInJapan":@"1",@"imgStr":str} result:result];
}
+(void)requestLikeListResult:(APIRequestResult)result{
    
    [ZWAPIRequestTool requestWithAPI:@"http://35.241.126.186:8080/travel/getImageLikeList" parameters:@{@"phone":@"13235910535",@"token":@"15a54619-e630-4f68-bcc7-9e24f0a9bb65"} result:result];
}
// 通用请求接口，针对接收字典参数的接口
+ (void)requestWithAPI:(NSString *)API parameters:(id)params result:(APIRequestResult)result {
    NSLog(@"通用请求借口传出的参数:%@",params);
    
    //[ZWAPIRequestTool buildParameters:params ? params : @{}]
    [ZWNetworkingManager postWithURLString:API
                                    params:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSLog(@"访问到服务器");
                                       if (result) {
                                           
                                           result(responseObject, YES);
                                       }
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       
                                       if (result) {
                                           result(error, NO);
                                       }
                                   }];
    
}


+ (id)buildParameters:(id)param {
    
    if ([param isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dict = [@{@"version": @1} mutableCopy];
        [dict addEntriesFromDictionary:param];
        return dict;
    } else if ([param isKindOfClass:[NSString class]]) {
        NSMutableString *validParams = [(NSString *)param mutableCopy];
        [validParams insertString:@"\n  \"version\":1" atIndex:1];
        return validParams;
    }
    return nil;
}



@end
