//  NetworkManager.m
//  CocoapodDemo
//  Author: Rana_Gamal

#import "NetworkManager.h"

static NSString *myServiceName;

@implementation NetworkManager 

+(void)connect:(NSURL *)url :(NSString *)serviceName :(NetworkManager*) networkManager{
    myServiceName = serviceName;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:networkManager];
    [connection start];
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _myData =[NSMutableData new];
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_myData appendData:data];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [_networkDelegate handle:_myData :myServiceName :1];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    printf("Error");
    [_networkDelegate handle:_myData :myServiceName :0];

    
    
}

@end
