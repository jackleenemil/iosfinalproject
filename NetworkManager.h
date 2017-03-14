//  NetworkManager.h
//  CocoapodDemo
//  Author: Rana_Gamal

#import <Foundation/Foundation.h>
#import "JETSNetworkDelegate.h"

@interface NetworkManager : NSObject <NSURLConnectionDelegate , NSURLConnectionDataDelegate>

@property NSMutableData *myData;
@property id <JETSNetworkDelegate> networkDelegate;
+(void) connect:(NSURL*) url : (NSString*) serviceName :(NetworkManager*) networkManager;

@end
