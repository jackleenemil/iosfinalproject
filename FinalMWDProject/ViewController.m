//
//  ViewController.m
//  MyProject
//
//  Created by JETS on 2/22/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "User.h"
#import "DatabaseManager.h"
#import "SpeakersView.h"
#import "ExhibitorView.h"
#import "SessionView.h"
#import "MyAgenda.h"
#import "SWRevealViewController.h"
#import "RearViewController.h"
#import "FrontViewController.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import <UIImage+AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import <AFNetworking/AFImageDownloader.h>
#import "UIView+Toast.h"


@interface ViewController ()

@property DatabaseManager *db;

@property SWRevealViewController *mainRevealController;
@property NSUserDefaults *def;
@property bool isLogged;
@end


@implementation ViewController


// for test




- (void)viewDidLoad {
    _db =[DatabaseManager sharedinstance];
    [super viewDidLoad];
    
    _def =[NSUserDefaults standardUserDefaults];
    
    _isLogged =[_def boolForKey:@"isLogged"];
    
 

    
    SessionView *session = [[SessionView alloc] init];
    
    
    RearViewController *rearViewController = [[RearViewController alloc] init];
    
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:session];
    
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    _mainRevealController = [[SWRevealViewController alloc]
                                                    initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    
    
    
//    _mainRevealController.delegate = self;
    
//   [self presentViewController:_mainRevealController animated:NO completion:nil ];

    
    
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)viewDidAppear:(BOOL)animated{
    //[self presentViewController:_mainRevealController animated:NO completion:nil ];
 
    User *myUser =[User sharedInstance];
    
    if(_isLogged){
         
       User *user =[_db getUser];
        myUser.idd=user.idd;
        myUser.code=user.code;
        myUser.birthDate=user.birthDate;
        myUser.email=user.email;
        myUser.firstName=user.firstName;
        myUser.lastName=user.lastName;
        myUser.country_name=user.country_name;
        myUser.city_name=user.city_name;
        myUser.comp_name=user.comp_name;
        myUser.titlee=user.titlee;
        myUser.midName=user.midName;
        myUser.gender=user.gender;
        myUser.img_url=user.img_url;
        myUser.img=user.img;

        
       [self presentViewController:_mainRevealController animated:NO completion:nil ];
        
        
    }
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






-(void)register:(id)sender{
    
    NSURL *url = [NSURL URLWithString:@"http://www.mobiledeveloperweekend.net/attendee/registration.htm"];
    
     NSString  *stringurl=url.absoluteString;
    
    if( [stringurl rangeOfString:@"http://www."].location != NSNotFound)
    {
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
   
    }

    
    
}




-(void)loginAction:(id)sender{
    printf("done");
    
    
    
    NSString *serviceName=@"login";
    
    NSString *user =_userName.text;
    NSString *pass =_password.text;
    NSString *serviceURL = [[[@"http://www.mobiledeveloperweekend.net/service/login?userName=" stringByAppendingString:user] stringByAppendingString:@"&password="]stringByAppendingString:pass ];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to log in "                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        
        [alert show];
        
    }else{
    
      
    
        [self connectToService:serviceName WithURL:serviceURL];
        
        
        [self.view makeToastActivity:CSToastPositionCenter];
    
        
    }
        
    
}



-(void)handle:(NSData *)dataRetreived :(NSString *)serviceName :(int) check{
    
    if([dataRetreived length]==0){
        printf("0");
    }
    
    
    if ([serviceName isEqualToString:@"login"]) {
        
        
        if(check==1){
            
            
            NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
            
            [def setObject:_password.text forKey:_userName.text];
            
            NSString *user1 =_userName.text;
            
            [def setObject:user1 forKey:@"user"];
            
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataRetreived options:0 error:nil];
            
                       
            if([[dict objectForKey:@"status"]isEqualToString:@"view.success"]){
                
                NSDictionary *result = [dict objectForKey:@"result"];
                User *user = [User sharedInstance];
                [user setIdd:[[result objectForKey:@"id"] stringValue ]];
                [user setCode:[result objectForKey:@"code"]];
                NSString *b=[result objectForKey:@"birthDate"];
                
                
                if(b ==(NSString*)[NSNull null]){
                    [user setBirthDate:@" "];
                }
                else
                {
                    [user setBirthDate:[result objectForKey:@"birthDate"]];
                    
                }
                
                
                
                [user setEmail:[result objectForKey:@"email"]];
                [user setFirstName:[result objectForKey:@"firstName"]];
                [user setLastName:[result objectForKey:@"lastName"]];
                
                NSString *t=[result objectForKey:@"countryName"];
                
                if(t ==(NSString*)[NSNull null]){
                    [user setCountry_name:@" "];
                }
                else
                {
                    [user setCountry_name:[result objectForKey:@"countryName"]];
                    
                }
                [user setCity_name:[result objectForKey:@"cityName"]];
                [user setComp_name:[result objectForKey:@"companyName"]];
                [user setTitlee:[result objectForKey:@"title"]];
                [user setPhones:[result objectForKey:@"phones"]];
                [user setMobiles:[result objectForKey:@"mobiles"]];
                [user setMidName:[result objectForKey:@"middleName"]];
                NSString *s=[result objectForKey:@"gender"];
                
                if(s ==(NSString*)[NSNull null]){
                    [user setGender:@" "];
                }
                else
            {
                    [user setGender:[result objectForKey:@"gender"]];
                    
                }
                
                [user setImg_url:[result objectForKey:@"imageURL"]];
                
                NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[user img_url]]];
                
                               
                
               
               
                    
                
                    AFImageDownloader* dwn = [AFImageDownloader defaultInstance];
                    [dwn downloadImageForURLRequest:req success:^(NSURLRequest* req, NSHTTPURLResponse* resp, UIImage* img) {
                        printf("image downloaded");
                      
                        
                         NSData *imageData = UIImagePNGRepresentation(img);
                        
                        [_db addImageInUser:user.idd :imageData];
                        
                    } failure:^(NSURLRequest* req, NSHTTPURLResponse* resp, NSError* error){
                        printf("image error");
                    }];
                    
                    
                
                
                
                
                [_db deleteAllUsers];
                
                [_db addUsers:user];
                
                
              //  SessionView *session=[SessionView new];
                printf("done2");
                
                [_def setBool:YES forKey:@"isLogged"];
                [_def setObject:_userName.text forKey:@"hisEmail"];
                
                  [self.view hideToastActivity];
                
            [self presentViewController:_mainRevealController animated:NO completion:nil ];
                
                
            }else{
                // worng password
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log in failed"
                                                                message:@"Worng username or password"                                                       delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                  [self.view hideToastActivity];
                
                [alert show];
                

                
                
                
            }
            
            
            
            
            
        }else{
            
            /// no network
            
            ///alert for network
            
        
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                            message:@"You have lost connection "                                                       delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [self.view hideToastActivity];
            
            [alert show];
            

            
            
        
        }
            
            
            
            
            
            
            
            
        }
        
        
        
    }





-(void)connectToService :(NSString*) serviceName WithURL :(NSString*) serviceURLString {
    
    NSURL *url = [NSURL URLWithString:serviceURLString];
    
    NetworkManager *network = [NetworkManager new];
    
    [network setNetworkDelegate:self];
    
    [NetworkManager connect:url:serviceName:network];
}



@end
