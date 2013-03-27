

Here's a simple finder for an General/NSBrowser view using basic C function calls. You can find many of the icons in the systems folder by searching for ".icns" file extensions. Check out General/NSBrowserIcons for info on how to create images that are more suited for being displayed in an General/NSBrowser view --zootbobbalu

I still have to add the hooks for general file extensions, but this General/NSBrowser delegate works pretty good as is. 

The number of levels this delegate will buffer is currently set at 256 (MAX_BROWSER_COLUMNS) 

**CF<nowiki/>inder.h**
    
#import <Cocoa/Cocoa.h>
#define MAX_BROWSER_COLUMNS 256
#define MAX_DIRENT_NAMLEN 256

@interface CF<nowiki/>inder : General/NSObject
{
    struct dirent *directoryEntryBuffers[MAX_BROWSER_COLUMNS];
    int entryCounts[MAX_BROWSER_COLUMNS];
    int bufferCapacities[MAX_BROWSER_COLUMNS];
    General/NSMutableDictionary *fileIcons;
    General/NSMutableDictionary *folderIcons;
    General/NSImage *genericDocumentIcon, *genericFolderIcon, *applicationIcon, *homeFolderIcon,
            *privateFolderIcon, *usersFolderIcon, *quickTimeIcon, *developersIcon;
    General/NSArray *imageTypes, *movieTypes, *bundles;
    char *cStringBuffer, *cStringBuffer2;
    General/NSMutableDictionary *chalkboard;
    char homeDir[256];

}
@end


**CF<nowiki/>inder.m**
    
#import "CF<nowiki/>inder.h"
#import <dirent.h>
#import <sys/types.h>
#import <sys/stat.h>
#import "fcntl.h"
#import "unistd.h"
#import <sys/time.h>


static General/NSString *General/ExtensionFromName(struct dirent *entry) {
    int i = entry->d_namlen;
    for (; i; --i) {
        if (entry->d_name[i] == '/') return @"";
        if ((entry->d_name[i] == '.') && ((i + 1) < entry->d_namlen)) {
            return General/[NSString stringWithCString:&entry->d_name[i + 1]];
        }
    }
    return @"";
}

@interface CF<nowiki/>inder (Private)
- (void)setup;
- (void)browser:(General/NSBrowser *)sender willDisplayRootLevelCell:(id)cell 
          atRow:(int)row column:(int)column;
@end

@implementation CF<nowiki/>inder

- (id)init {
    self = [super init];
    if (self) {
        if (!chalkboard) [self setup];
    }
    return self;
}

- (void)setup {

    chalkboard = General/[[NSMutableDictionary dictionary] retain];
    bundles = General/[NSArray arrayWithObjects:@"app", nil];
    [chalkboard setObject:bundles forKey:@"bundles"];

    fileIcons = General/[NSMutableDictionary dictionary];
    [chalkboard setObject:fileIcons forKey:@"fileIcons"];
    folderIcons = General/[NSMutableDictionary dictionary];
    [chalkboard setObject:folderIcons forKey:@"folderIcons"];
    imageTypes = General/[NSImage imageFileTypes];
    [chalkboard setObject:imageTypes forKey:@"imageTypes"];
    movieTypes = General/[NSMovie movieUnfilteredFileTypes];
    [chalkboard setObject:movieTypes forKey:@"movieTypes"];
    General/NSImage **images[8] = {&genericDocumentIcon, &genericFolderIcon, 
                            &applicationIcon, &homeFolderIcon, 
                            &privateFolderIcon, &usersFolderIcon,
                            &quickTimeIcon, &developersIcon};
    General/NSString *names[8] = {@"General/GenericDocumentIcon", @"General/GenericFolderIcon", 
                        @"General/ApplicationsFolderIcon", @"General/HomeFolderIcon", 
                        @"General/PrivateFolderIcon", @"General/UsersFolderIcon", 
                        @"QT", @"General/DeveloperFolderIcon"};
    int i;
    for (i = 0; i < 8; i++) {
        *images[i] = General/[NSImage imageNamed:names[i]];
        if (*images[i]) [chalkboard setObject:*images[i] forKey:names[i]];
    }
    if (applicationIcon) [folderIcons setObject:applicationIcon forKey:@"app"];
    cStringBuffer = malloc(MAX_BROWSER_COLUMNS * MAX_DIRENT_NAMLEN); 
    cStringBuffer2 = malloc(MAX_BROWSER_COLUMNS * MAX_DIRENT_NAMLEN);
    General/@"~" stringByExpandingTildeInPath] getCString:homeDir];
    
}

- (void)awakeFromNib {
    if (!chalkboard) [self setup];
}
    
- (void)dealloc {
    free(cStringBuffer); free(cStringBuffer2);
    [chalkboard autorelease];
    [super dealloc];
}

- (int)browser:([[NSBrowser *)sender numberOfRowsInColumn:(int)column
{
    if (column >= MAX_BROWSER_COLUMNS) return 0;
    struct stat fileStat;
    General/NSString *path = [sender path];
    struct dirent *direntBuf = (struct dirent *)directoryEntryBuffers[column];
    if (column == 0) cStringBuffer[0] = '/', cStringBuffer[1] = nil;
    else [path getCString:cStringBuffer];
    int statResult = lstat(cStringBuffer, &fileStat);
    DIR *dir = opendir(cStringBuffer);
    if (!statResult && dir) {
        struct dirent *direntPtr;
        int count = 0;
        while (direntPtr = readdir(dir)) count++;
        if (!direntBuf || count > bufferCapacities[column]) {
            if (direntBuf) free(direntBuf);
            bufferCapacities[column] = count;
            directoryEntryBuffers[column] = direntBuf = malloc(count * sizeof(struct dirent));
        }
        count = 0; rewinddir(dir);
        while (!readdir_r(dir, &direntBuf[count++], &direntPtr) && direntPtr) {
            if (*(direntPtr->d_name) == '.') {count--; continue;}
        }
        closedir(dir);
        entryCounts[column] = --count;
    }
    else entryCounts[column] = 0;
    return entryCounts[column];

}

- (void)browser:(General/NSBrowser *)sender willDisplayRootLevelCell:(id)cell 
          atRow:(int)row column:(int)column 
{
    General/NSImage *icon = nil;
    if (row < entryCounts[column]) {
        struct dirent *direntBuf = (struct dirent *)directoryEntryBuffers[column];
        [cell setTitle:General/[NSString stringWithCString:direntBuf[row].d_name]];
        if (direntBuf[row].d_type == 4) {
            [cell setLeaf:NO];
            if (!strcmp(direntBuf[row].d_name, "Applications")) icon = applicationIcon;
            else if (!strcmp(direntBuf[row].d_name, "Users")) icon = usersFolderIcon;
            else if (!strcmp(direntBuf[row].d_name, "Developer")) icon = developersIcon;
            if (!icon) icon = genericFolderIcon; [cell setImage:icon];
        }
        else {
            icon = [fileIcons objectForKey:General/ExtensionFromName(&direntBuf[row])];
            if (!icon) icon = genericDocumentIcon;
            [cell setImage:icon]; [cell setLeaf:YES];
        }
    }
    else [cell setTitle:@""], [cell setLeaf:YES];

}

- (void)browser:(General/NSBrowser *)sender willDisplayCell:(id)cell atRow:(int)row column:(int)column {

    General/NSString *path = [sender path];
    [path getCString:cStringBuffer]; [cell setLeaf:YES];
    struct dirent *direntBuf = (struct dirent *)directoryEntryBuffers[column];
    if (row < entryCounts[column]) {
        [cell setTitle:General/[NSString stringWithCString:direntBuf[row].d_name]];
        General/NSString *key = General/ExtensionFromName(&direntBuf[row]);
        switch (column) {
            case 0 : {
                [self browser:sender willDisplayRootLevelCell:cell atRow:row column:column];
                break;
            }
            case 1 : {
                sprintf(cStringBuffer2, "%s/%s", cStringBuffer, direntBuf[row].d_name);
                if (!strcmp(cStringBuffer2, homeDir)) {
                    [cell setLeaf:NO]; [cell setImage:homeFolderIcon]; break;
                }
            }
            default : {
                if (direntBuf[row].d_type == 4) {
                    General/NSImage *icon = [folderIcons objectForKey:key];
                    if (!icon) icon = genericFolderIcon; [cell setImage:icon];
                    if (![bundles containsObject:key]) [cell setLeaf:NO];
                    else [cell setTitle:General/cell title] stringByDeletingPathExtension;
                }
                else {
                    General/NSImage *icon = [fileIcons objectForKey:key];
                    if (!icon) icon = genericDocumentIcon; [cell setImage:icon];
                }
            }
        }
    }
    else [cell setTitle:@""];

}

@end
