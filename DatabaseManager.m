//
//  DatabaseManager.m
//  CocoapodDemo
//
//  Created by JETS on 2/28/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager



-(void)addImageInUser : (NSString*)idd : (NSData*)img{
    
    
    sqlite3_stmt    *statement=nil;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *myInsert  =[NSString stringWithFormat:@"UPDATE USER SET IMG =? WHERE ID=\"%@\"",idd];
        
        const char* sqliteQuery= [myInsert UTF8String];
        
        if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
        {
            
            sqlite3_bind_blob(statement,1, [img bytes], [img length], SQLITE_TRANSIENT);
            
            sqlite3_step(statement);
            
            
            
            
        }
        
        sqlite3_finalize(statement);
        
        
    }
    
    
    sqlite3_close(_contactDB);
    
    

    
    
}


//

//
//  DatabaseManager.m
//  MyProject
//
//  Created by JETS on 2/22/17.
//  Copyright © 2017 JETS. All rights reserved.
//



// method for singleton design
+(DatabaseManager*)sharedinstance{
    
    static DatabaseManager *d=nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once,^{
        d=[[DatabaseManager alloc] init];
    });
    
    return d;
}

//---------------------------//-------------------//---------------------//-------------------//-----------------//
//method for session object

-(Session*)getSession:(NSString*)idd{
    Session *mySession;
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ID, NAME , LOCATION ,DESCRIPTION ,STATUS ,STARTDATE  ,ENDDATE ,TYPE ,LIKED ,TAG FROM SESSION1 WHERE ID=\"%@\"",
                              idd];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                mySession=[Session new];
                NSString *idd = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 0)];
                NSString *name=[[NSString alloc]
                                initWithUTF8String:(const char *)
                                sqlite3_column_text(statement, 1)];
                
                NSString *location=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 2)];
                NSString *desc=[[NSString alloc]
                                initWithUTF8String:(const char *)
                                sqlite3_column_text(statement, 3)];
                
                NSString *status=[[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 4)];
                
                
                NSString *startDate=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 5)];
                NSString *endDate=[[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 6)];
                NSString *type=[[NSString alloc]
                                initWithUTF8String:(const char *)
                                sqlite3_column_text(statement, 7)];
                NSString *liked=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 8)];
                NSString *tag=[[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 9)];
                
                
                mySession.idd=idd;
                mySession.name=name;
                mySession.locationn=location;
                mySession.desc=desc;
                mySession.status=status;
                mySession.startDate=startDate;
                mySession.startDate=startDate;
                mySession.endDate=endDate;
                mySession.type=type;
                if([liked isEqualToString:@"YES"]){
                    mySession.isLiked=YES;
                }else{
                    mySession.isLiked=NO;
                }
                mySession.sessionTag=tag;
                
            } else {
                mySession=nil;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }
    
    
    return mySession;
}

//-------------------//-------------------//--------------------//--------------------//----------------------//

-(bool)deleteAllSessions{
    
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    bool check =NO;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"delete from SESSION1"]  ;
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            check= YES;
            
        } else {
            
            check= NO;
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
        
    }
    
    return check;
}

//-------------------//----------------------//--------------------//----------------------//----------------//
-(NSMutableArray*)getAllSessions{
    
    NSMutableArray *arr=[NSMutableArray new];
    int i =0;
    Session *mySession;
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ID, NAME , LOCATION ,DESCRIPTION ,STATUS ,STARTDATE  ,ENDDATE ,TYPE ,LIKED ,TAG ,DAY FROM SESSION1"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                mySession=[Session new];
                NSString *idd = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 0)];
                NSString *name=[[NSString alloc]
                                initWithUTF8String:(const char *)
                                sqlite3_column_text(statement, 1)];
                
                NSString *location=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 2)];
                NSString *desc=[[NSString alloc]
                                initWithUTF8String:(const char *)
                                sqlite3_column_text(statement, 3)];
                
                NSString *status=[[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 4)];
                
                
                NSString *startDate=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 5)];
                NSString *endDate=[[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 6)];
                NSString *type=[[NSString alloc]
                                initWithUTF8String:(const char *)
                                sqlite3_column_text(statement, 7)];
                NSString *liked=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 8)];
                NSString *tag=[[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 9)];
                
                NSString *day=[[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 10)];
                
                mySession.idd=idd;
                mySession.name=name;
                mySession.locationn=location;
                mySession.desc=desc;
                mySession.status=status;
                mySession.startDate=startDate;
                mySession.startDate=startDate;
                mySession.endDate=endDate;
                mySession.type=type;
                mySession.day=day;
                if([liked isEqualToString:@"YES"]){
                    mySession.isLiked=YES;
                }else{
                    mySession.isLiked=NO;
                }
                mySession.sessionTag=tag;
                
                
                arr[i]=mySession;
                i++;
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }
    
    
    return arr;
    
}

//--------------//-----------------//---------------------//--------------------//--------------//---------------//

-(bool)addSessions:(NSMutableArray<Session*>*)arr{
    
    sqlite3_stmt    *statement=nil;
    const char *dbpath = [_databasePath UTF8String];
    bool check =NO;
    
    Session *mySession=[Session new];
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        for(int i=0;i<[arr count];i++){
            NSString *liked;
            if(arr[i].isLiked==YES){
                liked=@"YES";
            }else{
                liked=@"NO";
            }
            mySession=arr[i];
            
            char* sqliteQuery ="INSERT INTO SESSION1 (ID,NAME,LOCATION,DESCRIPTION,STATUS,STARTDATE,ENDDATE,TYPE,LIKED,TAG,DAY) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
            
            
            if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
            {
                sqlite3_bind_text(statement, 1, [mySession.idd UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 2, [mySession.name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [mySession.locationn UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [mySession.desc UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_text(statement, 5, [mySession.status UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 6, [mySession.startDate UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 7, [mySession.endDate UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 8, [mySession.type UTF8String], -1, SQLITE_TRANSIENT);
                ;
                sqlite3_bind_text(statement, 9, [liked UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 10, [mySession.sessionTag UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 11, [mySession.day UTF8String], -1, SQLITE_TRANSIENT);
                check=sqlite3_step(statement);
                
            }
            else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(_contactDB);
    
    return check;
    
    
    
}

//---------------//---------------//--------------------//----------------------//---------------//----------------//
//method for speaker

-(NSMutableArray*)getAllSpeakers{
    NSMutableArray *speakers=[NSMutableArray new];
    
    
    int i =0;
    Speaker *mySpeaker;
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ID , FIRSTNAME , LASTNAME ,TITLE,COMPANYNAME ,MIDDLENAME ,BIOGRAPHY ,imgurl ,IMAGE ,GENDER  FROM SPEAKER"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                mySpeaker=[Speaker new];
                mySpeaker.idd = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 0)];
                mySpeaker.fName=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 1)];
                
                mySpeaker.lName=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 2)];
                
                
                mySpeaker.titlee=[[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 3)];
                
                
                mySpeaker.companyName=[[NSString alloc]
                                       initWithUTF8String:(const char *)
                                       sqlite3_column_text(statement, 4)];
                
                mySpeaker.middleName=[[NSString alloc]
                                      initWithUTF8String:(const char *)
                                      sqlite3_column_text(statement, 5)];
                
                
                mySpeaker.biography=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 6)];
                
                mySpeaker.imageURL=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 7)];
                int length = sqlite3_column_bytes(statement, 8);
                
                mySpeaker.img  = [NSData dataWithBytes:sqlite3_column_blob(statement, 8) length:length];
                
                mySpeaker.gender=[[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 9)];
                
                
                
                
                
                
                //---------------------------------------------------------------------------------//
                sqlite3_stmt    *statement2;
                NSMutableArray *phones=[NSMutableArray new];
                
                NSString *querySQL2 = [NSString stringWithFormat:
                                       @"SELECT ID,PHONES FROM SPEAKERPHONES WHERE ID=\"%@\"",
                                       mySpeaker.idd];
                
                const char *query_stmt2 = [querySQL2 UTF8String];
                
                if (sqlite3_prepare_v2(_contactDB,
                                       query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
                {
                    
                    while(sqlite3_step(statement2) == SQLITE_ROW)
                    {
                        
                        NSString *phone=[[NSString alloc]
                                         initWithUTF8String:(const char *)
                                         sqlite3_column_text(statement2, 1)];
                        
                        [phones addObject:phone];
                        
                    }
                    mySpeaker.phones=phones;
                    
                    sqlite3_finalize(statement2);
                }
                //--------------------------------------------------------------------------------//
                sqlite3_stmt    *statement3;
                NSMutableArray *mobiles=[NSMutableArray new];
                
                NSString *querySQL3 = [NSString stringWithFormat:
                                       @"SELECT ID,MOBILES FROM SPEAKERMOBILES WHERE ID=\"%@\"",
                                       mySpeaker.idd];
                
                const char *query_stmt3 = [querySQL3 UTF8String];
                
                if (sqlite3_prepare_v2(_contactDB,
                                       query_stmt3, -1, &statement3, NULL) == SQLITE_OK)
                {
                    
                    while(sqlite3_step(statement3) == SQLITE_ROW)
                    {
                        
                        NSString *mobile=[[NSString alloc]
                                          initWithUTF8String:(const char *)
                                          sqlite3_column_text(statement3, 1)];
                        
                        [mobiles addObject:mobile];
                        
                    }
                    mySpeaker.mobiles=mobiles;
                    
                    
                    sqlite3_finalize(statement3);
                }
                
                //-----------------------------------------------------------------------------------------------------------//
                
                
                speakers[i]=mySpeaker;
                
                
                i++;
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }
    
    return speakers;
}

//--------------//------------------//------------------//------------------//--------------------//---------------//

-(Speaker*)getSpeaker:(NSString*)idd{
    Speaker *mySpeaker;
    
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ID , FIRSTNAME , LASTNAME ,TITLE,COMPANYNAME ,MIDDLENAME ,BIOGRAPHY ,imgurl ,IMAGE ,GENDER  FROM SPEAKER WHERE ID=\"%@\"",
                              idd];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                mySpeaker=[Speaker new];
                mySpeaker.idd = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 0)];
                mySpeaker.fName=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 1)];
                
                mySpeaker.lName=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 2)];
                
                
                mySpeaker.titlee=[[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 3)];
                
                
                
                mySpeaker.companyName=[[NSString alloc]
                                       initWithUTF8String:(const char *)
                                       sqlite3_column_text(statement, 4)];
                
                mySpeaker.middleName=[[NSString alloc]
                                      initWithUTF8String:(const char *)
                                      sqlite3_column_text(statement, 5)];
                
                
                mySpeaker.biography=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 6)];
                
                
                mySpeaker.imageURL=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 7)];
                
                int length = sqlite3_column_bytes(statement, 8);
                
                mySpeaker.img  = [NSData dataWithBytes:sqlite3_column_blob(statement, 8) length:length];
                
                mySpeaker.gender=[[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 9)];
                
                
                
            }
            sqlite3_finalize(statement);
        }
        
        //---------------------------------------------------------------------------------//
        sqlite3_stmt    *statement2;
        NSMutableArray *phones=[NSMutableArray new];
        
        NSString *querySQL2 = [NSString stringWithFormat:
                               @"SELECT ID , PHONES  FROM SPEAKERPHONES WHERE ID=\"%@\"",
                               idd];
        
        const char *query_stmt2 = [querySQL2 UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(statement2) == SQLITE_ROW)
            {
                
                NSString *phone=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement2, 1)];
                
                [phones addObject:phone];
                
            }
            mySpeaker.phones=phones;
            
            sqlite3_finalize(statement2);
        }
        //--------------------------------------------------------------------------------//
        sqlite3_stmt    *statement3;
        NSMutableArray *mobiles=[NSMutableArray new];
        
        NSString *querySQL3 = [NSString stringWithFormat:
                               @"SELECT ID , MOBILES FROM SPEAKERMOBILES WHERE ID=\"%@\"",
                               idd];
        
        const char *query_stmt3 = [querySQL3 UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt3, -1, &statement3, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(statement3) == SQLITE_ROW)
            {
                
                NSString *mobile=[[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement3, 1)];
                
                [mobiles addObject:mobile];
                
            }
            mySpeaker.mobiles=mobiles;
            
            
            sqlite3_finalize(statement3);
        }
        
        //---------------------------------------------------------------------------------------------//
        
        
        
        
        
        sqlite3_close(_contactDB);
    }
    
    
    return mySpeaker;
}

//------------------//----------------------//------------------//------------------------//-----------------//

-(bool)deleteAllSpeakers{
    
    
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    bool check1 =NO;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *deleteSQL = [NSString stringWithFormat:
                               @"delete from SPEAKERPHONES"]  ;
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, delete_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            check1= YES;
            
        } else {
            
            check1= NO;
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    }
    
    
    //-------------------------------------------------------------------------------------//
    sqlite3_stmt    *statement2;
    bool check2 =NO;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *deleteSQL2 = [NSString stringWithFormat:
                                @"delete from SPEAKERMOBILES"]  ;
        
        const char *delete_stmt2 = [deleteSQL2 UTF8String];
        sqlite3_prepare_v2(_contactDB, delete_stmt2,
                           -1, &statement2, NULL);
        if (sqlite3_step(statement2) == SQLITE_DONE)
        {
            check2= YES;
            
        } else {
            
            check2= NO;
        }
        sqlite3_finalize(statement2);
        sqlite3_close(_contactDB);
    }
    //-----------------------------------------------------------------------------------------//
    
    sqlite3_stmt    *statement3;
    bool check3 =NO;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *deleteSQL3 = [NSString stringWithFormat:
                                @"delete from SPEAKER"]  ;
        
        const char *delete_stmt3 = [deleteSQL3 UTF8String];
        sqlite3_prepare_v2(_contactDB, delete_stmt3,
                           -1, &statement3, NULL);
        if (sqlite3_step(statement3) == SQLITE_DONE)
        {
            check3= YES;
            
        } else {
            
            check3= NO;
        }
        sqlite3_finalize(statement3);
        sqlite3_close(_contactDB);
    }
    
    return check3;
}

//------------------//--------------//----------------//--------------------//----------------//-------------------//


-(void)addImageInExihibtors : (NSString*)idd : (NSData* )img{
    
    sqlite3_stmt    *statement=nil;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *myInsert  =[NSString stringWithFormat:@"UPDATE EXHIBITORS SET IMG =? WHERE ID=\"%@\"",idd];
        
        const char* sqliteQuery= [myInsert UTF8String];
        
        if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
        {
            
            sqlite3_bind_blob(statement,1, [img bytes], [img length], SQLITE_TRANSIENT);
            
            sqlite3_step(statement);
            
            
            
            
        }
        
        sqlite3_finalize(statement);
        
        
    }
    
    
    sqlite3_close(_contactDB);
    

    
    
}



//--------------//-------------------/----------------//-----------------------//-----------------//------------------//

-(void)addImageInSpeaker: (NSString*)idd :(NSData*)img{
    sqlite3_stmt    *statement=nil;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *myInsert  =[NSString stringWithFormat:@"UPDATE SPEAKER SET IMAGE =? WHERE ID=\"%@\"",idd];
        
        const char* sqliteQuery= [myInsert UTF8String];
        
        if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
        {
            
            sqlite3_bind_blob(statement,1, [img bytes], [img length], SQLITE_TRANSIENT);
            
            sqlite3_step(statement);
            
            
            
            
        }
        
        sqlite3_finalize(statement);
        
        
    }
    
    
    sqlite3_close(_contactDB);
    
    
}





//------------------------//------------------------//----------------------------------///------------

-(bool)addSpeakers:(NSMutableArray*)arr{
    
    bool check =NO;
    bool check2 =NO;
    bool check3 =NO;
    Speaker *mySpeaker=[Speaker new];
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt* statement=nil;
    
    sqlite3_stmt* statement2=nil;
    sqlite3_stmt* statement3=nil;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        for (int i=0;i< [arr count];i++) {
            mySpeaker=arr[i];
            
            
            char* sqliteQuery ="INSERT INTO SPEAKER (ID , FIRSTNAME, LASTNAME,TITLE,COMPANYNAME,MIDDLENAME,BIOGRAPHY,imgurl,IMAGE,GENDER)VALUES (?,?,?,?,?,?,?,?,?,?)";
            
            
            if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
            {
                sqlite3_bind_text(statement, 1, [mySpeaker.idd UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 2, [mySpeaker.fName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [mySpeaker.lName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [mySpeaker.titlee UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_text(statement, 5, [mySpeaker.companyName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 6, [mySpeaker.middleName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 7, [mySpeaker.biography UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 8, [mySpeaker.imageURL UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_blob(statement, 9, [mySpeaker.img bytes], [mySpeaker.img length], SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 10, [mySpeaker.gender UTF8String], -1, SQLITE_TRANSIENT);
                
                check=sqlite3_step(statement);
                
                
                
                
                
                
                //---------------------------------------------------------------------------------------------//
                
                
                NSArray *phones=[NSArray new];
                phones=mySpeaker.phones;
                for(int k=0;k<[phones count];k++)
                {
                    char* sqliteQuery2="INSERT INTO SPEAKERPHONES (ID,PHONES)VALUES (?,?)";
                    if( sqlite3_prepare_v2(_contactDB, sqliteQuery2, -1, &statement2, NULL) == SQLITE_OK )
                    {
                        sqlite3_bind_text(statement2, 1, [mySpeaker.idd UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(statement2, 2, [phones[k] UTF8String], -1, SQLITE_TRANSIENT);
                        
                        check2=sqlite3_step(statement2);
                        sqlite3_finalize(statement2);

                        
                    }
                    else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
                    //sqlite3_finalize(statement2);

                }
                // Finalize and close database.
                
                
                
                //---------------------------------------------------------------------------------------------//
                
                NSArray *mobiles=[NSArray new];
                mobiles=mySpeaker.mobiles;
                for(int k=0;k<[mobiles count];k++)
                {
                    char* sqliteQuery3="INSERT INTO SPEAKERMOBILES (ID,MOBILES)VALUES (?,?)";
                    
                    if( sqlite3_prepare_v2(_contactDB, sqliteQuery3, -1, &statement3, NULL) == SQLITE_OK )
                    {
                        sqlite3_bind_text(statement3, 1, [mySpeaker.idd UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(statement3, 2, [mobiles[k] UTF8String], -1, SQLITE_TRANSIENT);
                        
                        check3=sqlite3_step(statement3);
                        sqlite3_finalize(statement3);
                        
                        
                    }
                    else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
                    sqlite3_finalize(statement3);
                    
                }
                
                
                
            }
            else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
            
            
        }
        
        
        
        
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        
        
        
        
    }
    sqlite3_close(_contactDB);
    
    
    
    
    
    return check;
}

//--------------------//---------------------//--------------------//------------------//-----------------------//


-(Exhibitors *)getExhibitor:(NSString *)idd
{
    Exhibitors *myExhibitor=[Exhibitors new];
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ID, address , email ,countryname ,cityname  ,companyname ,fax ,contactname ,contacttitle ,companyurl ,imgurl , img FROM EXHIBITORS WHERE ID=\"%@\"",
                              idd];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *idd = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 0)];
                NSString *address=[[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 1)];
                
                NSString *email=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 2)];
                
                NSString *country_name=[[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 3)];
                
                
                NSString *city_name=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 4)];
                
                
                NSString *comp_name=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 5)];
                
                NSString *about=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 6)];
                NSString *fax=[[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 7)];
                
                NSString *contact_name=[[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 8)];
                
                NSString *contact_title=[[NSString alloc]
                                         initWithUTF8String:(const char *)
                                         sqlite3_column_text(statement, 9)];
                
                NSString *comp_url=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 10)];
                
                NSString *img_url=[[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 11)];
                
                int length= sqlite3_column_bytes(statement, 12);
                NSData *img =[NSData dataWithBytes:sqlite3_column_blob(statement, 12) length:length];
                
                myExhibitor.idd=idd;
                myExhibitor.address=address;
                myExhibitor.email=email;
                myExhibitor.country_name=country_name;
                myExhibitor.city_name=city_name;
                myExhibitor.comp_name=comp_name;
                myExhibitor.about=about;
                myExhibitor.fax=fax;
                myExhibitor.contact_name=contact_name;
                myExhibitor.contact_title=contact_title;
                myExhibitor.comp_url=comp_url;
                myExhibitor.img_url=img_url;
                myExhibitor.img=img;
                
                
            }
            else
            {
                myExhibitor=nil;
            }
            
            
            sqlite3_finalize(statement);
            
            
        }
        //---------------------------------------------------------------------------------//
        sqlite3_stmt    *statement2;
        NSMutableArray *phones=[NSMutableArray new];
        
        NSString *querySQL2 = [NSString stringWithFormat:
                               @"SELECT ID,PHONES FROM EXPHONES WHERE ID=\"%@\"",
                               idd];
        
        const char *query_stmt2 = [querySQL2 UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(statement2) == SQLITE_ROW)
            {
                
                NSString *phone=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement2, 1)];
                
                [phones addObject:phone];
                
            }
            myExhibitor.phons=phones;
            
            
            sqlite3_finalize(statement2);
        }
        //--------------------------------------------------------------------------------//
        sqlite3_stmt    *statement3;
        NSMutableArray *mobiles=[NSMutableArray new];
        
        NSString *querySQL3 = [NSString stringWithFormat:
                               @"SELECT ID,MOBILES FROM EXMOBILES WHERE ID=\"%@\"",
                               idd];
        
        const char *query_stmt3 = [querySQL3 UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt3, -1, &statement3, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(statement3) == SQLITE_ROW)
            {
                
                NSString *mobile=[[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement3, 1)];
                
                [mobiles addObject:mobile];
                
            }
            myExhibitor.mobiles=mobiles;
            
            
            sqlite3_finalize(statement3);
        }
        
        //---------------------------------------------------------------------------------------------//
        sqlite3_close(_contactDB);
    }
    
    return myExhibitor;
}

//>>>>>>>>>>>>>>//>>>>>>>>>>>>>//>>>>>>>>>>>>>>>>>>>//>>>>>>>>>>>>>>>>>>>>//>>>>>>>>>>>>>>>>>>>>//



-(User *)getUser
{
    
    User *myuser=[User new];
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ID ,code , birthdate ,email ,firstname ,lastname,countryname ,cityname TEXT,companyname ,title ,middlename ,gender ,img_url , img   FROM user "];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *idd = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 0)];
                NSString *code=[[NSString alloc]
                                initWithUTF8String:(const char *)
                                sqlite3_column_text(statement, 1)];
                
                NSString *birthdate=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 2)];
                
                NSString *email=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 3)];
                
                
                NSString *firstname=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 4)];
                
                
                NSString *lastname=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 5)];
                
                NSString *country_name=[[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 6)];
                NSString *city_name=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 7)];
                
                NSString *comp_name=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 8)];
                
                NSString *title=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 9)];
                
                NSString *mid_name=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 10)];
                
                NSString *gender=[[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 11)];
                
                NSString *img_url=[[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 12)];
                
                int length= sqlite3_column_bytes(statement, 13);
                NSData *img =[NSData dataWithBytes:sqlite3_column_blob(statement, 13) length:length];
                
                
                
                myuser.idd=idd;
                myuser.code=code;
                myuser.birthDate=birthdate;
                myuser.email=email;
                myuser.firstName=firstname;
                myuser.lastName=lastname;
                myuser.country_name=country_name;
                myuser.city_name=city_name;
                myuser.comp_name=comp_name;
                myuser.titlee=title;
                myuser.midName=mid_name;
                myuser.gender=gender;
                myuser.img_url=img_url;
                myuser.img=img;
                
                
            }
            
            else
            {
                myuser=nil;
            }
            sqlite3_finalize(statement);
        }
        
        //---------------------------------------------------------------------------------//
        sqlite3_stmt    *statement2;
        NSMutableArray *phones=[NSMutableArray new];
        
        NSString *querySQL2 = [NSString stringWithFormat:
                               @"SELECT ID , PHONES  FROM userphones "];
        
        
        const char *query_stmt2 = [querySQL2 UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(statement2) == SQLITE_ROW)
            {
                
                NSString *phone=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement2, 1)];
                
                [phones addObject:phone];
                
            }
            myuser.phones=phones;
            
            sqlite3_finalize(statement2);
        }
        //--------------------------------------------------------------------------------//
        sqlite3_stmt    *statement3;
        NSMutableArray *mobiles=[NSMutableArray new];
        
        NSString *querySQL3 = [NSString stringWithFormat:
                               @"SELECT ID , MOBILES FROM usermobiles "];
        
        const char *query_stmt3 = [querySQL3 UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt3, -1, &statement3, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(statement3) == SQLITE_ROW)
            {
                
                NSString *mobile=[[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement3, 1)];
                
                [mobiles addObject:mobile];
                
            }
            myuser.mobiles=mobiles;
            
            
            sqlite3_finalize(statement3);
        }
        
        //---------------------------------------------------------------------------------------------//
        sqlite3_close(_contactDB);
    }
    
    return myuser;
}


//-------------//---------------------//-------------//-------------//---------------//-----------------//
-(NSMutableArray *)getAllExhibitors
{
    NSMutableArray *exhibitors=[NSMutableArray new];
    
    int i =0;
    Exhibitors *myExhibitor;
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              
                              
                              @"SELECT ID , address , email,countryname ,cityname ,companyname ,about,fax ,contactname ,contacttitle ,companyurl ,imgurl, img FROM EXHIBITORS"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                myExhibitor=[Exhibitors new];
                
                NSString *idd = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 0)];
                NSString *address=[[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 1)];
                
                NSString *email=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 2)];
                
                NSString *country_name=[[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 3)];
                
                
                NSString *city_name=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 4)];
                
                
                NSString *comp_name=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 5)];
                
                NSString *about=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 6)];
                NSString *fax=[[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 7)];
                
                NSString *contact_name=[[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 8)];
                
                NSString *contact_title=[[NSString alloc]
                                         initWithUTF8String:(const char *)
                                         sqlite3_column_text(statement, 9)];
                
                NSString *comp_url=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 10)];
                
                NSString *img_url=[[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 11)];
                
                
                int length= sqlite3_column_bytes(statement, 12);
                NSData *img =[NSData dataWithBytes:sqlite3_column_blob(statement, 12) length:length];
                
                myExhibitor.idd=idd;
                myExhibitor.address=address;
                myExhibitor.email=email;
                myExhibitor.country_name=country_name;
                myExhibitor.city_name=city_name;
                myExhibitor.comp_name=comp_name;
                myExhibitor.about=about;
                myExhibitor.fax=fax;
                myExhibitor.contact_name=contact_name;
                myExhibitor.contact_title=contact_title;
                myExhibitor.comp_url=comp_url;
                myExhibitor.img_url=img_url;
                myExhibitor.img=img;
                
                //---------------------------------------------------------------------------------//
                sqlite3_stmt    *statement2;
                NSMutableArray *phones=[NSMutableArray new];
                
                NSString *querySQL2 = [NSString stringWithFormat:
                                       @"SELECT ID, PHONES FROM EXPHONES WHERE ID=\"%@\"",
                                       idd];
                
                const char *query_stmt2 = [querySQL2 UTF8String];
                
                if (sqlite3_prepare_v2(_contactDB,
                                       query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
                {
                    
                    while(sqlite3_step(statement2) == SQLITE_ROW)
                    {
                        
                        NSString *phone=[[NSString alloc]
                                         initWithUTF8String:(const char *)
                                         sqlite3_column_text(statement2, 1)];
                        
                        [phones addObject:phone];
                        
                    }
                    myExhibitor.phons=phones;
                    
                    
                    sqlite3_finalize(statement2);
                }
                
                //-------------------------------------------------------------------------------------------------------//
                sqlite3_stmt    *statement3;
                NSMutableArray *mobiles=[NSMutableArray new];
                
                NSString *querySQL3 = [NSString stringWithFormat:
                                       @"SELECT ID , MOBILES FROM EXMOBILES WHERE ID=\"%@\"",
                                       idd];
                
                const char *query_stmt3 = [querySQL3 UTF8String];
                
                if (sqlite3_prepare_v2(_contactDB,
                                       query_stmt3, -1, &statement3, NULL) == SQLITE_OK)
                {
                    
                    while(sqlite3_step(statement3) == SQLITE_ROW)
                    {
                        
                        NSString *mobile=[[NSString alloc]
                                          initWithUTF8String:(const char *)
                                          sqlite3_column_text(statement3, 1)];
                        
                        [mobiles addObject:mobile];
                        
                    }
                    myExhibitor.mobiles=mobiles;
                    
                    
                    sqlite3_finalize(statement3);
                }
                
                //-----------------------------------------------------------------------------------------------------------//
                
                exhibitors[i]=myExhibitor;
                i++;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
        
    }
    return  exhibitors;
}
//------------//---------------//----------------//--------------//----------------//-----------//---------//

-(NSMutableArray *)getAllUsers
{
    
    NSMutableArray *users=[NSMutableArray new];
    
    int i =0;
    User *myuser;
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM USER"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                myuser=[User new];
                
                NSString *idd =[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                
                NSString *code=[[NSString alloc]
                                initWithUTF8String:(const char *)
                                sqlite3_column_text(statement, 1)];
                
                NSString *birthdate=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 2)];
                
                NSString *email=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 3)];
                
                
                NSString *firstname=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 4)];
                
                
                NSString *lastname=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 5)];
                
                NSString *country_name=[[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 6)];
                NSString *city_name=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 7)];
                
                NSString *comp_name=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 8)];
                
                NSString *title=[[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 9)];
                
                NSString *mid_name=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 10)];
                
                NSString *gender=[[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 11)];
                
                NSString *img_url=[[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 12)];
                
                int length= sqlite3_column_bytes(statement, 13);
                NSData *img =[NSData dataWithBytes:sqlite3_column_blob(statement, 13) length:length];
                
                
                
                myuser.idd=idd;
                myuser.code=code;
                myuser.birthDate=birthdate;
                myuser.email=email;
                myuser.firstName=firstname;
                myuser.lastName=lastname;
                myuser.country_name=country_name;
                myuser.city_name=city_name;
                myuser.comp_name=comp_name;
                [myuser setTitlee:title];
                myuser.midName=mid_name;
                myuser.gender=gender;
                myuser.img_url=img_url;
                myuser.img=img;
                
                //---------------------------------------------------------------------------------//
                sqlite3_stmt    *statement2;
                NSMutableArray *phones=[NSMutableArray new];
                
                NSString *querySQL2 = [NSString stringWithFormat:
                                       @"SELECT ID,PHONES FROM userphones WHERE ID=\"%@\"",
                                       idd];
                
                const char *query_stmt2 = [querySQL2 UTF8String];
                
                if (sqlite3_prepare_v2(_contactDB,
                                       query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
                {
                    
                    while(sqlite3_step(statement2) == SQLITE_ROW)
                    {
                        
                        NSString *phone=[[NSString alloc]
                                         initWithUTF8String:(const char *)
                                         sqlite3_column_text(statement2, 1)];
                        
                        [phones addObject:phone];
                        
                    }
                    myuser.phones=phones;
                    
                    sqlite3_finalize(statement2);
                }
                //--------------------------------------------------------------------------------//
                sqlite3_stmt    *statement3;
                NSMutableArray *mobiles=[NSMutableArray new];
                
                NSString *querySQL3 = [NSString stringWithFormat:
                                       @"SELECT ID,MOBILES FROM usermobiles WHERE ID=\"%@\"",
                                       idd];
                
                const char *query_stmt3 = [querySQL3 UTF8String];
                
                if (sqlite3_prepare_v2(_contactDB,
                                       query_stmt3, -1, &statement3, NULL) == SQLITE_OK)
                {
                    
                    while(sqlite3_step(statement3) == SQLITE_ROW)
                    {
                        
                        NSString *mobile=[[NSString alloc]
                                          initWithUTF8String:(const char *)
                                          sqlite3_column_text(statement3, 1)];
                        
                        [mobiles addObject:mobile];
                        
                    }
                    myuser.mobiles=mobiles;
                    
                    
                    sqlite3_finalize(statement3);
                }
                
                //-----------------------------------------------------------------------------------------------------------//
                users[i]=myuser;
                i++;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }
    return users;
}



//--------------------//-----------------------//---------------------//------------------//---------------------//


-(bool)deleteAllExhibitors{
    
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    bool check1 =NO;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *deleteSQL = [NSString stringWithFormat:
                               @"delete from EXPHONES"]  ;
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, delete_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            check1= YES;
            
        } else {
            
            check1= NO;
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    }
    
    
    //-------------------------------------------------------------------------------------//
    sqlite3_stmt    *statement2;
    bool check2 =NO;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *deleteSQL2 = [NSString stringWithFormat:
                                @"delete from EXMOBILES"]  ;
        
        const char *delete_stmt2 = [deleteSQL2 UTF8String];
        sqlite3_prepare_v2(_contactDB, delete_stmt2,
                           -1, &statement2, NULL);
        if (sqlite3_step(statement2) == SQLITE_DONE)
        {
            check2= YES;
            
        } else {
            
            check2= NO;
        }
        sqlite3_finalize(statement2);
        sqlite3_close(_contactDB);
    }
    //-----------------------------------------------------------------------------------------//
    
    sqlite3_stmt    *statement3;
    bool check3 =NO;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *deleteSQL3 = [NSString stringWithFormat:
                                @"delete from EXHIBITORS "]  ;
        
        const char *delete_stmt3 = [deleteSQL3 UTF8String];
        sqlite3_prepare_v2(_contactDB, delete_stmt3,
                           -1, &statement3, NULL);
        if (sqlite3_step(statement3) == SQLITE_DONE)
        {
            check3= YES;
            
        } else {
            
            check3= NO;
        }
        sqlite3_finalize(statement3);
        sqlite3_close(_contactDB);
    }
    //3ndi so2al hna
    return check3;
}

//--------------------//-----------------//--------------------//---------------------//-----------------------------//

-(bool)deleteAllUsers
{
    
    
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    bool check1 =NO;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *deleteSQL = [NSString stringWithFormat:
                               @"delete from userphones"]  ;
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, delete_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            check1= YES;
            
        } else {
            
            check1= NO;
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    }
    
    
    //-------------------------------------------------------------------------------------//
    sqlite3_stmt    *statement2;
    bool check2 =NO;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *deleteSQL2 = [NSString stringWithFormat:
                                @"delete from usermobiles"]  ;
        
        const char *delete_stmt2 = [deleteSQL2 UTF8String];
        sqlite3_prepare_v2(_contactDB, delete_stmt2,
                           -1, &statement2, NULL);
        if (sqlite3_step(statement2) == SQLITE_DONE)
        {
            check2= YES;
            
        } else {
            
            check2= NO;
        }
        sqlite3_finalize(statement2);
        sqlite3_close(_contactDB);
    }
    //-----------------------------------------------------------------------------------------//
    
    sqlite3_stmt    *statement3;
    bool check3 =NO;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *deleteSQL3 = [NSString stringWithFormat:
                                @"delete from USER"]  ;
        
        const char *delete_stmt3 = [deleteSQL3 UTF8String];
        sqlite3_prepare_v2(_contactDB, delete_stmt3,
                           -1, &statement3, NULL);
        if (sqlite3_step(statement3) == SQLITE_DONE)
        {
            check3= YES;
            
        } else {
            
            check3= NO;
        }
        sqlite3_finalize(statement3);
        sqlite3_close(_contactDB);
    }
    //3ndi so2al hna
    return check3;
}
//-----------------//------------------//----------------------//--------------------//-------------------//

-(bool)addExhibitors:(NSMutableArray *)arr
{
    
    bool check =NO;
    bool check2 =NO;
    bool check3 =NO;
    
    Exhibitors *myExhibitor=[Exhibitors new];
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt* statement=nil;
    sqlite3_stmt* statement2=nil;
    sqlite3_stmt* statement3=nil;
    
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        for (int i=0;i< [arr count];i++)
        {
            
            myExhibitor=arr[i];
            
            
            char* sqliteQuery ="INSERT INTO EXHIBITORS (ID, address, email,countryname,cityname,companyname,about,fax,contactname,contacttitle,companyurl,imgurl,img) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
            
            
            if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
            {
                sqlite3_bind_text(statement, 1, [myExhibitor.idd UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 2, [myExhibitor.address UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [myExhibitor.email UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [myExhibitor.country_name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 5, [myExhibitor.city_name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 6, [myExhibitor.comp_name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 7, [myExhibitor.about UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 8, [myExhibitor.fax UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 9, [myExhibitor.contact_name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 10, [myExhibitor.contact_title UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 11, [myExhibitor.comp_url UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_text(statement, 12, [myExhibitor.img_url UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_blob(statement, 13, [myExhibitor.img bytes], [myExhibitor.img length], SQLITE_TRANSIENT);
                
                check=sqlite3_step(statement);
                
                
                
                //---------------------------------------------------------------------------------------------//
                
                
                NSMutableArray *phones=[NSMutableArray new];
                phones=myExhibitor.phons;
                for(int k=0;k<[phones count];k++)
                {
                    char* sqliteQuery2="INSERT INTO EXPHONES (ID, PHONES) VALUES (?,?)";
                    if( sqlite3_prepare_v2(_contactDB, sqliteQuery2, -1, &statement2, NULL) == SQLITE_OK )
                    {
                        sqlite3_bind_text(statement2, 1, [myExhibitor.idd UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(statement2, 2, [phones[k] UTF8String], -1, SQLITE_TRANSIENT);
                        
                        check2=sqlite3_step(statement2);
                        
                        
                        // Finalize and close database.
                        sqlite3_finalize(statement2);
                    }
                    else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
                    
                    // Finalize and close database.
                    sqlite3_finalize(statement2);
                    
                }
                
                
                
                
                //---------------------------------------------------------------------------------------------//
                
                NSMutableArray *mobiles=[NSMutableArray new];
                mobiles=myExhibitor.mobiles;
                for(int k=0;k<[mobiles count];k++)
                {
                    char* sqliteQuery3="INSERT INTO EXMOBILES (ID,MOBILES) VALUES (?,?)";
                    if( sqlite3_prepare_v2(_contactDB, sqliteQuery3, -1, &statement3, NULL) == SQLITE_OK )
                    {
                        sqlite3_bind_text(statement3, 1, [myExhibitor.idd UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(statement3, 2, [mobiles[k] UTF8String], -1, SQLITE_TRANSIENT);
                        
                        check3=sqlite3_step(statement3);
                        
                    }
                    else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
                }
                // Finalize and close database.
                sqlite3_finalize(statement3);
                
                
            }
            else
            {NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );}
            
            
        }
        
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(_contactDB);
    
    //hna fe so2al
    return check;
}
//---------//-------------------//----------------//--------------------//------------------//-----------------//

-(bool)addUsers:(User *) myUser
{
    bool check =NO;
    bool check2 =NO;
    bool check3 =NO;
    
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt* statement=nil;
    sqlite3_stmt* statement2=nil;
    sqlite3_stmt* statement3=nil;
    
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        
        
        
        char* sqliteQuery ="INSERT INTO USER (ID,code, birthdate,email,firstname,lastname,countryname ,cityname,companyname,title,middlename,gender,img_url, img)VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        
        if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
        {
            sqlite3_bind_text(statement, 1, [myUser.idd UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement, 2, [myUser.code UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [myUser.birthDate UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [myUser.email UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [myUser.firstName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [myUser.lastName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7, [myUser.country_name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 8, [myUser.city_name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9, [myUser.comp_name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 10, [myUser.titlee UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 11, [myUser.midName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 12, [myUser.gender UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 13, [myUser.img_url UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_blob(statement, 14, [myUser.img bytes], [myUser.img length], SQLITE_TRANSIENT);
            printf("insert");
            check=sqlite3_step(statement);
            
            
            
            //---------------------------------------------------------------------------------------------//
            
            
            NSMutableArray *phones=[NSMutableArray new];
            phones=myUser.phones;
            for(int k=0;k<[phones count];k++)
            {
                char* sqliteQuery2="INSERT INTO userphones (ID,PHONES)VALUES (?,?)";
                if( sqlite3_prepare_v2(_contactDB, sqliteQuery2, -1, &statement2, NULL) == SQLITE_OK )
                {
                    sqlite3_bind_text(statement2, 1, [myUser.idd UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement2, 2, [phones[k] UTF8String], -1, SQLITE_TRANSIENT);
                    
                    check2=sqlite3_step(statement2);
                    sqlite3_finalize(statement2);
                    
                    
                }
                else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
                sqlite3_finalize(statement2);
                
            }
            
            //---------------------------------------------------------------------------------------------//
            
            NSMutableArray *mobiles=[NSMutableArray new];
            mobiles=myUser.mobiles;
            for(int k=0;k<[mobiles count];k++)
            {
                char* sqliteQuery3="INSERT INTO usermobiles (ID,MOBILES)VALUES (?,?)";
                if( sqlite3_prepare_v2(_contactDB, sqliteQuery3, -1, &statement3, NULL) == SQLITE_OK )
                {
                    sqlite3_bind_text(statement3, 1, [myUser.idd UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement3, 2, [mobiles[k] UTF8String], -1, SQLITE_TRANSIENT);
                    
                    check3=sqlite3_step(statement3);
                    
                }
                
                else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
            }
            
            // Finalize and close database.
            sqlite3_finalize(statement3);
            
            
            
        }else
        {NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );}
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(_contactDB);
    
    //hna fe so2al
    return check;
}

//--------------------//-------------------//------------------//------------//--------------//

-(bool)deleteAllSeSpeaker
{
    
    
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    bool check =NO;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"delete from SESPEAKER"]  ;
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            check= YES;
            
        } else {
            
            check= NO;
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
        
    }
    
    return check;
}

//-----------------//---------//-----------------//----------------//----------------------//

-(bool)addSeSpeakers:(NSArray *)arr :(NSString *)sid
{
 
   
    
    sqlite3_stmt    *statement=nil;
    const char *dbpath = [_databasePath UTF8String];
    bool check =NO;
    
    Speaker *mySeSpeaker=[Speaker new];
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        
        for(int i=0;i<[arr count];i++){
            
            mySeSpeaker=arr[i];
            
            char* sqliteQuery ="INSERT INTO SESPEAKER ( IDSession, IDSPEAKER, FIRSTNAME ,LASTNAME,TITLE,COMPANYNAME,MIDDLENAME,BIOGRAPHY,IMGURL,IMAGE, GENDER) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
            
            
            if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
            {
                sqlite3_bind_text(statement, 1, [sid UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 2, [mySeSpeaker.idd UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [mySeSpeaker.fName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [mySeSpeaker.lName UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_text(statement, 5, [mySeSpeaker.titlee UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 6, [mySeSpeaker.companyName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 7, [mySeSpeaker.middleName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 8, [mySeSpeaker.biography UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 9, [mySeSpeaker.imageURL UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_blob(statement, 10, [mySeSpeaker.img bytes], [mySeSpeaker.img length], SQLITE_TRANSIENT);
                
                sqlite3_bind_text(statement, 11, [mySeSpeaker.gender UTF8String], -1, SQLITE_TRANSIENT);
                
                check=sqlite3_step(statement);
                
            }
            else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
            
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(_contactDB);
    
        
    
    return check;
}
//--------------------//-------------------//------------------//------------//--------------//
-(NSMutableArray *)getAllSeSpeakers:(NSString *)sid
{
    
    
    NSMutableArray *arr=[NSMutableArray new];
    int i =0;
    Speaker *mySeSpeaker;
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT IDSPEAKER, FIRSTNAME ,LASTNAME,TITLE,COMPANYNAME,MIDDLENAME,BIOGRAPHY,IMGURL,IMAGE, GENDER  FROM SESPEAKER WHERE IDSession=\"%@\"",
                              sid];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                mySeSpeaker=[Speaker new];
                
                
                
                mySeSpeaker.idd = [[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 0)];
                mySeSpeaker.fName=[[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 1)];
                
                mySeSpeaker.lName=[[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 2)];
                
                
                mySeSpeaker.titlee=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 3)];
                
                
                mySeSpeaker.companyName=[[NSString alloc]
                                         initWithUTF8String:(const char *)
                                         sqlite3_column_text(statement, 4)];
                
                mySeSpeaker.middleName=[[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 5)];
                
                
                mySeSpeaker.biography=[[NSString alloc]
                                       initWithUTF8String:(const char *)
                                       sqlite3_column_text(statement, 6)];
                
                mySeSpeaker.imageURL=[[NSString alloc]
                                      initWithUTF8String:(const char *)
                                      sqlite3_column_text(statement, 7)];
                int length = sqlite3_column_bytes(statement, 8);
                
                mySeSpeaker.img  = [NSData dataWithBytes:sqlite3_column_blob(statement, 8) length:length];
                
                mySeSpeaker.gender=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 9)];
                
                arr[i]=mySeSpeaker;
                i++;
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }
    return arr;
    
}
//--------------------//-------------------//------------------//------------//--------------//


////tables creations

-(id)init{
    
    self= [super init];
    
    
    printf("object created");
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"MDW10.db"]];
    
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt =
        "CREATE TABLE IF NOT EXISTS SESSION1 (DB INTEGER PRIMARY KEY AUTOINCREMENT,ID TEXT, NAME TEXT, LOCATION TEXT,DESCRIPTION TEXT,STATUS TEXT,STARTDATE TEXT ,ENDDATE TEXT,TYPE TEXT,LIKED TEXT,TAG TEXT,DAY TEXT)";
        
        
        if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table");
        }
        
        
        //table speaker
        
        
        const char* sql_stmt2=
        "CREATE TABLE IF NOT EXISTS SPEAKER (DB INTEGER PRIMARY KEY AUTOINCREMENT,ID TEXT, FIRSTNAME TEXT, LASTNAME TEXT,TITLE TEXT,COMPANYNAME TEXT,MIDDLENAME TEXT,BIOGRAPHY TEXT,imgurl TEXT,IMAGE BLOB,GENDER TEXT)";
        
        
        
        if (sqlite3_exec(_contactDB, sql_stmt2, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table speakr");
        }
        
        //table Speaker_phones
        
        const char *sql_stmt3 =
        "CREATE TABLE IF NOT EXISTS SPEAKERPHONES (DB INTEGER PRIMARY KEY AUTOINCREMENT,ID TEXT, PHONES TEXT)";
        
        
        if (sqlite3_exec(_contactDB, sql_stmt3, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table SPEAKERPHONES ");
        }
        
        //table speaker mobies
        
        const char *sql_stmt4 =
        "CREATE TABLE IF NOT EXISTS SPEAKERMOBILES (DB INTEGER PRIMARY KEY AUTOINCREMENT,ID TEXT, MOBILES TEXT)";
        
        
        if (sqlite3_exec(_contactDB, sql_stmt4, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table SPEAKERMOBILES");
        }
        
        
        
        // table exhibitors
        
        const char *sql_stmt5 =
        "CREATE TABLE IF NOT EXISTS EXHIBITORS (DB INTEGER PRIMARY KEY AUTOINCREMENT,ID TEXT, address TEXT, email TEXT,countryname TEXT,cityname TEXT ,companyname TEXT,about TEXT,fax TEXT,contactname TEXT,contacttitle TEXT,companyurl TEXT,imgurl TEXT, img BLOB)";
        
        
        if (sqlite3_exec(_contactDB, sql_stmt5, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table EXHIBITORS");
        }
        
        //table exhibitors_phones
        
        const char *sql_stmt6 =
        "CREATE TABLE IF NOT EXISTS EXPHONES (DB INTEGER PRIMARY KEY AUTOINCREMENT,ID TEXT, PHONES TEXT)";
        
        
        if (sqlite3_exec(_contactDB, sql_stmt6, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table EXPHONES");
        }
        
        //table exhibitors mobies
        
        const char *sql_stmt7 =
        "CREATE TABLE IF NOT EXISTS EXMOBILES (DB INTEGER PRIMARY KEY AUTOINCREMENT,ID TEXT, MOBILES TEXT)";
        
        
        if (sqlite3_exec(_contactDB, sql_stmt7, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table EXMOBILES");
        }
        
        //table user
        
        const char *sql_stmt8 =
        "CREATE TABLE IF NOT EXISTS USER (DB INTEGER PRIMARY KEY AUTOINCREMENT,ID TEXT,code TEXT, birthdate TEXT,email TEXT,firstname TEXT ,lastname TEXT,countryname TEXT,cityname TEXT,companyname TEXT,title TEXT,middlename TEXT,gender TEXT,img_url TEXT, img BLOB,status TEXT)";
        
        
        if (sqlite3_exec(_contactDB, sql_stmt8, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table user");
        }
        
        // table user phones
        
        const char *sql_stmt9 =
        "CREATE TABLE IF NOT EXISTS userphones (DB INTEGER PRIMARY KEY AUTOINCREMENT,ID TEXT, PHONES TEXT)";
        
        
        if (sqlite3_exec(_contactDB, sql_stmt9, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table userphones");
        }
        
        //table user mobiles
        
        const char *sql_stmt10 =
        "CREATE TABLE IF NOT EXISTS usermobiles (DB INTEGER PRIMARY KEY AUTOINCREMENT,ID TEXT, MOBILES TEXT)";
        
        
        if (sqlite3_exec(_contactDB, sql_stmt10, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table userMOBILES");
        }
        
        
        
        
        // table sessionspeaker
        
        const char *sql_stmt11 =
        "CREATE TABLE IF NOT EXISTS SESPEAKER (DB INTEGER PRIMARY KEY AUTOINCREMENT,IDSession TEXT, IDSPEAKER TEXT, FIRSTNAME TEXT, LASTNAME TEXT,TITLE TEXT,COMPANYNAME TEXT,MIDDLENAME TEXT,BIOGRAPHY TEXT,imgurl TEXT,IMAGE BLOB,GENDER TEX)";
        
        
        if (sqlite3_exec(_contactDB, sql_stmt11, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table sessionspeaker");
        }
        
        
        //--------//-----------//-------------//
        
        sqlite3_close(_contactDB);
        
    } else {
        printf("Failed to open/create database");
    }
    
    
    
    
    
    printf("object created fifnish");
    
    
    
    return self;
    
    
    
}




//

@end
