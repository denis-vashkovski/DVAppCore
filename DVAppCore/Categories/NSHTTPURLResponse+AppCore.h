//
//  NSHTTPURLResponse+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse(AppCore)
- (BOOL)ac_isStatusCorrect;
@end

#define STATUS_CODE_CONTINUE                            100
#define STATUS_CODE_SWITCHING_PROTOCOLS                 101
#define STATUS_CODE_OK                                  200
#define STATUS_CODE_CREATED                             201
#define STATUS_CODE_ACCEPTED                            202
#define STATUS_CODE_NON_AUTHORITATIVE_INFORMATION       203
#define STATUS_CODE_NO_CONTENT                          204
#define STATUS_CODE_RESET_CONTENT                       205
#define STATUS_CODE_PARTIAL_CONTENT                     206
#define STATUS_CODE_MULTIPLE_CHOICES                    300
#define STATUS_CODE_MOVED_PERMANENTLY                   301
#define STATUS_CODE_FOUND                               302
#define STATUS_CODE_SEE_OTHER                           303
#define STATUS_CODE_NOT_MODIFIED                        304
#define STATUS_CODE_USE_PROXY                           305
#define STATUS_CODE_TEMPORARY_REDIRECT                  307
#define STATUS_CODE_BAD_REQUEST                         400
#define STATUS_CODE_UNAUTHORIZED                        401
#define STATUS_CODE_PAYMENT_REQUIRED                    402
#define STATUS_CODE_FORBIDDEN                           403
#define STATUS_CODE_NOT_FOUND                           404
#define STATUS_CODE_METHOD_NOT_ALLOWED                  405
#define STATUS_CODE_NOT_ACCEPTABLE                      406
#define STATUS_CODE_PROXY_AUTHENTICATION_REQUIRED       407
#define STATUS_CODE_REQUEST_TIMEOUT                     408
#define STATUS_CODE_CONFLICT                            409
#define STATUS_CODE_GONE                                410
#define STATUS_CODE_LENGTH_REQUIRED                     411
#define STATUS_CODE_PRECONDITION_FAILED                 412
#define STATUS_CODE_PAYLOAD_TOO_LARGE                   413
#define STATUS_CODE_URI_TOO_LONG                        414
#define STATUS_CODE_UNSUPPORTED_MEDIA_TYPE              415
#define STATUS_CODE_RANGE_NOT_SATISFIABLE               416
#define STATUS_CODE_EXPECTATION_FAILED                  417
#define STATUS_CODE_UPGRADE_REQUIRED                    426
#define STATUS_CODE_INTERNAL_SERVER_ERROR               500
#define STATUS_CODE_NOT_IMPLEMENTED                     501
#define STATUS_CODE_BAD_GATEWAY                         502
#define STATUS_CODE_SERVICE_UNAVAILABLE                 503
#define STATUS_CODE_GATEWAY_TIME_OUT                    504
#define STATUS_CODE_HTTP_VERSION_NOT_SUPPORTED          505
#define STATUS_CODE_PROCESSING                          102
#define STATUS_CODE_MULTI_STATUS                        207
#define STATUS_CODE_IM_USED                             226
#define STATUS_CODE_PERMANENT_REDIRECT                  308
#define STATUS_CODE_UNPROCESSABLE_ENTITY                422
#define STATUS_CODE_LOCKED                              423
#define STATUS_CODE_FAILED_DEPENDENCY                   424
#define STATUS_CODE_PRECONDITION_REQUIRED               428
#define STATUS_CODE_TOO_MANY_REQUESTS                   429
#define STATUS_CODE_REQUEST_HEADER_FIELDS_TOO_LARGE     431
#define STATUS_CODE_UNAVAILABLE_FOR_LEGAL_REASONS       451
#define STATUS_CODE_VARIANT_ALSO_NEGOTIATES             506
#define STATUS_CODE_INSUFFICIENT_STORAGE                507
#define STATUS_CODE_NETWORK_AUTHENTICATION_REQUIRED     511
#define STATUS_CODE_DEVELOPER_ERROR                     700
