//  JETSNetworkDelegate.h
//  CocoapodDemo
//  Created by Rana on 2/22/17.


#import <Foundation/Foundation.h>

@protocol JETSNetworkDelegate <NSObject>

-(void) handle:(NSData*) dataRetreived :(NSString*) serviceName :(int)check;


@end

