//
//  Album.h
//  SpinCity
//
//  Created by Choon Yan, CY 2014
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Album : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * locationInStore;

@end
