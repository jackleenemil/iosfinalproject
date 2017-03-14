//
//  User.h
//  MyProject
//
//  Created by JETS on 2/24/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property NSString *idd;
@property NSString *code;
@property NSString *birthDate;
@property NSString *email;
@property NSString *firstName;
@property NSString *lastName;
@property NSString *country_name;
@property NSString *city_name;
@property NSString *comp_name;
@property NSString *titlee;
@property NSMutableArray *phones;
@property NSMutableArray *mobiles;
@property NSString *midName;
@property NSString *gender;
@property NSString *img_url;
@property NSData *img;

+(User*)sharedInstance;

@end
