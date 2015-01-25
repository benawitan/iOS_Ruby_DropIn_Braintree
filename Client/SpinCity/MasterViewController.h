//
//  MasterViewController.h
//  SpinCity
//
//  Created by Choon Yan, CY 2014
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
