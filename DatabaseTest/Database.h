//
//  Database.h
//  DatabaseTest
//
//  Created by Gary Black on 3/19/13.
//  Copyright (c) 2013 Parkmeadow Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject
{
    sqlite3 *db;
    NSString *documentsDirectory;
}

+ (Database *)instance;

- (BOOL)create:(NSString *)dbName;
- (BOOL)open:(NSString *)dbFilePath;
- (BOOL)close;

@end