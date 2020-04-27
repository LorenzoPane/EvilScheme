#import <UIKit/UIKit.h>
#import <EvilKit/EvilKit.h>
#import "../L0Prefs/L0Prefs.h"
#import "EVSPortionVC.h"

@interface EVSOutlineVC : L0PrefVC <L0TextCellDelegate, L0PrefVCDelegate, UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray<NSObject<EVKURLPortion> *> *outline;
@property NSString *regex;
@property NSString *key;
@end
