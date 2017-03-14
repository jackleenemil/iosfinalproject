//
//  DatabaseManager.h
//  FinalMWDProject
//
//  Created by JETS on 3/6/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>
#import "Session.h"
#import "Speaker.h"
#import "Exhibitors.h"
#import "User.h"


@interface DatabaseManager : NSObject

@property (strong , nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactDB;


//add your methods here
+(DatabaseManager*)sharedinstance;
-(id)init;

-(Session*)getSession:(NSString*)idd;
-(NSMutableArray*)getAllSessions;
-(bool)deleteAllSessions;
-(bool)addSessions:(NSMutableArray*)arr;


-(NSMutableArray*)getAllSpeakers;
-(Speaker*)getSpeaker:(NSString*)idd;
-(bool)deleteAllSpeakers;
-(bool)addSpeakers:(NSMutableArray*)arr;


-(bool)deleteAllSeSpeaker;
-(bool)addSeSpeakers:(NSArray *)arr : (NSString *)sid;
-(NSMutableArray *)getAllSeSpeakers:(NSString *)sid;
-(void)addImageInSpeaker: (NSString*)idd :(NSData*)img;




-(Exhibitors *)getExhibitor:(NSString *)idd;
-(NSMutableArray*)getAllExhibitors;
-(bool)deleteAllExhibitors;
-(bool)addExhibitors:(NSMutableArray*)arr;
-(void)addImageInExihibtors : (NSString*)idd : (NSData* )img;


-(User *)getUser;
-(NSMutableArray*)getAllUsers;
-(bool)deleteAllUsers;
-(bool)addUsers:(User*)u;
-(void)addImageInUser : (NSString*)idd : (NSData*)img;
@end

