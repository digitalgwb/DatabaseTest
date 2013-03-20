//
//  Database.m
//  DatabaseTest
//
//  Created by Gary Black on 3/19/13.
//  Copyright (c) 2013 Parkmeadow Productions. All rights reserved.
//

#import "Database.h"
#import <sqlite3.h>

@implementation Database

+ (Database *)instance
{
    static Database *instance = nil;
    
    if (!instance)
    {
        instance = [[super allocWithZone:nil] init];
    }
    
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone;
{
    return [self instance];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
    }
    
    return self;
}

- (BOOL)create:(NSString *)dbName
{
    char *error;
    
    // Build the file name and path
    NSString *dbFileName = [NSString stringWithFormat:@"%@.sqlite", dbName];
    NSString *dbFilePath = [documentsDirectory stringByAppendingPathComponent:dbFileName];
    
    // Check if the db already exists.  If so, return YES
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL rc = NO;
    BOOL exists = [fileManager fileExistsAtPath:dbFilePath];
    
    if (exists)
        rc = YES;
    else if ([self open:dbFilePath])
    {
        // Database was successfully created - now create tables
        NSString *sql = @"CREATE TABLE IF NOT EXISTS TEST ( KEY INTEGER PRIMARY KEY AUTOINCREMENT );";
        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            rc = YES;
        }
        else
        {
            sqlite3_close(db);
        }
    }
    
    return rc;
}

- (BOOL)open:(NSString *)dbFilePath
{
    BOOL rc = NO;
    if (sqlite3_open([dbFilePath UTF8String], &db) == SQLITE_OK)
    {
        rc = YES;
    }
    else
    {
        sqlite3_close(db);
    }
    
    return rc;
}

- (BOOL)close
{
    return( sqlite3_close(db) == SQLITE_OK );
}
@end
